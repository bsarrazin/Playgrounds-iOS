import Foundation

extension MutableCollection {
    mutating func shuffle() {
        guard count > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: count, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let distance: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let index = self.index(firstUnshuffled, offsetBy: distance)
            swapAt(firstUnshuffled, index)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

postfix operator ~!
extension Int {
    static postfix func ~! (i: Int) -> Int {
        return i == 1 ? i : i * (i - 1)~!
    }
}

enum Suit: String {
    case clubs = "CLUBS"
    case diamonds = "DIAMONDS"
    case hearts = "HEARTS"
    case spades = "SPADES"
}

enum Rank: Int, CustomStringConvertible {
    case ace = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case jack = 11
    case queen = 12
    case king = 13
    
    var description: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default: return rawValue.description
        }
    }
    
    var rankValue: Int {
        switch self {
        case .jack, .queen, .king: return 10
        default: return rawValue
        }
    }
}

struct Card: CustomStringConvertible {
    var rank: Rank
    var suit: Suit
    
    var description: String { return rank.rawValue.description + " " + suit.rawValue }
}

struct Deck {
    
    enum InitialState {
        case ordered
        case shuffled
    }
    
    private(set) var cards: [Card]
    
    init(state: InitialState) {
        let ranks: [Rank] = [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
        let suits: [Suit] = [.hearts, .diamonds, .clubs, .spades]
        
        cards = []
        ranks.forEach { rank in
            suits.forEach { suit in
                cards.append(Card(rank: rank, suit: suit))
            }
        }
        
        if state == .shuffled { shuffle() }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func deal(nbCards: Int) -> [Card] {
        var cards: [Card] = []
        for _ in (0..<nbCards) {
            guard !self.cards.isEmpty else { break }
            cards.append(self.cards.removeLast())
        }
        return cards
    }
}

var deck = Deck(state: .shuffled)
let hand = deck.deal(nbCards: 6)
print(hand)

6~! / 4~! * (6~! - 4~!)
6~! / 4~! * (6 - 4)~!

func permute(hand: [Card]) -> [Card] {
    if hand.count == 0 { return [] }
    hand.indices.flatMap { i -> [Card] in
        var a = hand
        let e = a.remove(at: i)
        
        return [e] + permute(hand: a).map { [e].append(contentsOf: $0) }
    }
}

let foo = permute(hand: hand)
