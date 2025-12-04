// MARK: Day 20: Pulse Propagation -

import AdventOfCode
import Foundation

@Day struct Day20 {
    // MARK: -

    func part1() -> Int {
        Circuit.shared.reset()

        for _ in 0..<1000 {
            ButtonModule.shared.press()
            Circuit.shared.process()
        }

        return Circuit.shared.pulseCounters.product(of: \.value)
    }

    func part2() -> Int {
        Circuit.shared.reset()

        while true {
            ButtonModule.shared.press()
            Circuit.shared.process()

            if Circuit.shared.probes.product(of: \.value) != 0 { break }
        }

        return Circuit.shared.probes.values.reduce(with: lcm)
    }

    // MARK: - Data

    init(data: String) {
        var moduleOutputs: [String: [String]] = [:]
        var modules: [String: any Module] = [:]

        for line in data.lines() {
            let scanner = Scanner(string: String(line))

            let moduleID: String
            let module: any Module

            let moduleType = scanner.scanCharacter()!
            if moduleType == "b" {
                module = BroadcasterModule.shared
                moduleID = "broadcaster"
                _ = scanner.scanString("roadcaster")!
            } else {
                moduleID = scanner.scanCharacters(from: .letters)!
                module =
                    switch moduleType {
                    case "%": FlipFlopModule(id: moduleID)
                    case "&": ConjunctionModule(id: moduleID)
                    default: fatalError("Unknown module type")
                    }
            }

            _ = scanner.scanString("-> ")!

            let outputs = scanner.scanUpToCharacters(from: CharacterSet.newlines)!.split(separator: ", ")
                .map(String.init)
            moduleOutputs[moduleID] = outputs
            modules[moduleID] = module
        }

        for (id, outputs) in moduleOutputs {
            if outputs.contains(where: { modules[$0] == nil }) {
                modules[id]!.destinations = [DummyModule(id: id)]
            } else {
                modules[id]!.destinations = outputs.compactMap { modules[$0] }
            }
        }

        for conjunction in modules.values where conjunction is ConjunctionModule {
            let inputs = moduleOutputs.filter { $0.value.contains(conjunction.id) }.map {
                modules[$0.key]!
            }
            (conjunction as! ConjunctionModule).incomingModules = inputs
        }

        let gatewayToRX = moduleOutputs.filter { $0.value.contains("rx") }.first!.key
        let gateway = modules[gatewayToRX] as! ConjunctionModule
        for probeID in gateway.incomingModules.map({ $0.id }) { Circuit.shared.probes[probeID] = 0 }
    }
}

private enum Pulse: String {
    case high
    case low
}

private struct Signal: CustomStringConvertible {
    let source: any Module
    let destination: any Module
    let pulse: Pulse

    var description: String { source.id + " -" + pulse.rawValue + "-> " + destination.id }
}

private class Circuit: @unchecked Sendable {
    static let shared = Circuit()
    var buffers: [[Signal]] = [[], []]
    var currentBuffer = 0

    var probes: [String: Int] = [:]
    var pulseCounters: [Pulse: Int] = [.high: 0, .low: 0]

    var buffersEmpty: Bool { buffers.first?.count == 0 && buffers.last?.count == 0 }

    func enqueue(pulse: Pulse, from source: any Module, to destination: any Module) {
        let signal = Signal(source: source, destination: destination, pulse: pulse)
        buffers[currentBuffer].append(signal)
    }

    func flipBuffer() { currentBuffer = 1 - currentBuffer }

    func tick() {
        let signals = buffers[currentBuffer]
        buffers[currentBuffer] = []
        flipBuffer()

        for signal in signals {
            pulseCounters[signal.pulse]! += 1
            signal.destination.handlePulse(signal.pulse, from: signal.source)
        }
    }

    func process() { while !buffersEmpty { tick() } }

    func reset() {
        buffers = [[], []]
        currentBuffer = 0
    }
}

private protocol Module: Identifiable {
    var id: String { get }
    var destinations: [any Module] { get set }
    func handlePulse(_ pulse: Pulse, from source: any Module)
}

extension Module {
    func emitPulse(_ pulse: Pulse) {
        for destination in destinations {
            Circuit.shared.enqueue(pulse: pulse, from: self, to: destination)
        }
    }
}

private class FlipFlopModule: Module {
    let id: String
    var destinations: [any Module] = []
    var isOn = false

    init(id: String, destinations: [any Module] = []) {
        self.id = id
        self.destinations = destinations
    }

    func handlePulse(_ pulse: Pulse, from source: any Module) {
        if pulse == .low {
            isOn.toggle()
            emitPulse(isOn ? .high : .low)
        }
    }
}

private class ConjunctionModule: Module {
    let id: String
    var destinations: [any Module] = []
    var incomingModules: [any Module] = []
    var incomingStates: [String: Pulse] = [:]

    init(id: String, destinations: [any Module] = [], incomingModules: [any Module] = []) {
        self.id = id
        self.destinations = destinations
        self.incomingModules = incomingModules
    }

    func setState(_ pulse: Pulse, for module: any Module) { incomingStates[module.id] = pulse }

    func state(for module: any Module) -> Pulse { incomingStates[module.id] ?? .low }

    var periods: [String: UInt64] = [:]

    func handlePulse(_ pulse: Pulse, from source: any Module) {
        setState(pulse, for: source)

        if Circuit.shared.probes.keys.contains(id) {
            let result = incomingModules.contains { state(for: $0) != .high } ? Pulse.high : .low
            if result == .high, Circuit.shared.probes[id] == 0 {
                Circuit.shared.probes[id] = ButtonModule.shared.numberOfPresses
            }
        }
        emitPulse(incomingModules.contains { state(for: $0) != .high } ? .high : .low)
    }
}

private class BroadcasterModule: Module, @unchecked Sendable {
    static let shared = BroadcasterModule()
    let id = "broadcaster"
    var destinations: [any Module] = []

    func handlePulse(_ pulse: Pulse, from source: any Module) { emitPulse(pulse) }
}

private class ButtonModule: Module, @unchecked Sendable {
    static let shared = ButtonModule()
    var id = "button"
    var destinations: [any Module] = [BroadcasterModule.shared]

    var numberOfPresses = 0

    func handlePulse(_ pulse: Pulse, from source: any Module) {
        fatalError("Button doesn't handle pulses, use `press` instead.")
    }

    func press() {
        numberOfPresses += 1
        emitPulse(.low)
    }
}

private class DummyModule: Module {
    let id: String
    var destinations: [any Module] = []

    init(id: String, destinations: [any Module] = []) {
        self.id = id
        self.destinations = destinations
    }

    func handlePulse(_ pulse: Pulse, from source: any Module) {}
}
