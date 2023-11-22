import SwiftUI

// Setting different Suits for the Cards
enum Suit: Character
{
    case clubs = "C",
         diamonds = "D",
         hearts = "H",
         spades = "S"
}

// Setting different Ranks for the Cards
enum Rank: Int
{
    case ace = 1,
         two,
         three,
         four,
         five,
         six,
         seven,
         eight,
         nine,
         ten,
         jack,
         queen,
         king
}

// Creating the Card class
class Card
{
    // Creating variables that will need to be assigned
    private let rank: Rank
    private let suit: Suit
    
    // Class constructor
    init(_ rank: Rank, of suit: Suit)
    {
        self.rank = rank
        self.suit = suit
    }
    
    // Function to return Rank of the card
    func getRank() -> Rank
    {
        return rank
    }
    
    // Function to return Suit of the card
    func getSuit() -> Suit
    {
        return suit
    }
    
    func compareRank(with otherCard: Card) -> Bool
    {
        return rank == otherCard.getRank()
    }
    
    func compareSuit(with otherCard: Card) -> Bool
    {
        return suit == otherCard.getSuit()
    }
    
    // Print out a description of the card
    func describe()
    {
        print("The Card is", self.getRank(), "of", self.getSuit().rawValue)
    }
}

// Function to build an Array of type Card
// Ths allows the basic Deck to be built
func createDeck() -> [Card]
{
    let ranks = [Rank.ace,
                 Rank.two,
                 Rank.three,
                 Rank.four,
                 Rank.five,
                 Rank.six,
                 Rank.seven,
                 Rank.eight,
                 Rank.nine,
                 Rank.ten,
                 Rank.jack,
                 Rank.queen,
                 Rank.king]
    
    let suits = [Suit.clubs,
                 Suit.diamonds,
                 Suit.hearts,
                 Suit.spades]
    
    // Creating a blank Array to store the Card Deck
    var deck = [Card]()
    
    // Add the Cards to blank Deck Array
    for suit in suits
    {
        for rank in ranks
        {
            deck.append(Card(rank, of: suit))
        }
    }
    
    // Return the created Card Deck
    return deck
}

// Create a blank array to store the shuffled Deck
var shuffledDeck = [Card]()

// Creates the Deck and assigns it to the previous array
func createShuffledDeck()
{
    shuffledDeck = createDeck().shuffled()
}

// Create two blank arrays to split into the two game piles
var playerDeck = [Card]()
var computerDeck = [Card]()

// Splits the shuffled deck into two piles and assigns them to previous arrays
// Adds a Card to each pile then loops and repeats till all cards are assigned
func splitIntoTwoDecks()
{
    for _ in 1...26
    {
        playerDeck.append(shuffledDeck[0])
        shuffledDeck.removeFirst()
        
        computerDeck.append(shuffledDeck[0])
        shuffledDeck.removeFirst()
    }
}

// Returns first Card from player Deck
func dealFirstFromPlayerHand() -> Card
{
    var card: Card?
    
    card = playerDeck[0]
    
    return card!
}

// Return first Card from computer Deck
func dealFirstFromComputerHand() -> Card
{
    var card: Card?
    
    card = computerDeck[0]
    
    return card!
}

// Use the deal() functions to return the string for each Cards image
func getPlayerCardImage() -> String
{
    return "\(dealFirstFromPlayerHand().getRank().rawValue)\(dealFirstFromPlayerHand().getSuit().rawValue)"
}

func getComputerCardImage() -> String
{
     return "\(dealFirstFromComputerHand().getRank().rawValue)\(dealFirstFromComputerHand().getSuit().rawValue)"
}

func gameLogic()
{
    // Check if both piles have Cards remaining
    if (playerDeck.count != 0 || computerDeck.count != 0)
    {
        // Check if Ranks are the same for the Cards
        
        // If they are run further checks
        if (dealFirstFromPlayerHand().getRank() != dealFirstFromComputerHand().getRank())
        {
            // Get Card rank raw value so comparisson is possible
            let playerRank = dealFirstFromPlayerHand().getRank().rawValue
            let computerRank = dealFirstFromComputerHand().getRank().rawValue
            
            // If player Card is higher add both cards to player Deck
            if (playerRank > computerRank)
            {
                playerDeck.insert(computerDeck.remove(at: 0), at: playerDeck.count)
                playerDeck.insert(playerDeck.remove(at: 0), at: playerDeck.count)
            }
            // If computer Card is higher add both cards to computer Deck
            if (playerRank < computerRank)
            {
                computerDeck.insert(playerDeck.remove(at: 0), at: computerDeck.count)
                computerDeck.insert(computerDeck.remove(at: 0), at: computerDeck.count)
            }
        }
        // If they arent remove top Card and add to bottom of each Deck
        else
        {
            playerDeck.insert(playerDeck.remove(at: 0), at: playerDeck.count)
            computerDeck.insert(computerDeck.remove(at: 0), at: computerDeck.count)
        }
    }
}

// Creating the leaderboardEntry class as identifiable
struct LeaderboardEntry: Identifiable
{
    // Creating variables that will need to be assigned
    var id = UUID()
    var gameNumber: Int
    var roundsPlayed: Int
    var playerCardsRemaining: Int
    var computerCardsRemaining: Int
    var winner: String
    
    init(gameNumber: Int, roundsPlayed: Int, playerCardsRemaining: Int, computerCardsRemaining: Int)
    {
        self.gameNumber = gameNumber
        self.roundsPlayed = roundsPlayed
        self.playerCardsRemaining = playerCardsRemaining
        self.computerCardsRemaining = computerCardsRemaining
        
        if (playerCardsRemaining == computerCardsRemaining)
        {
            winner = "Draw"
        }
        else if (playerCardsRemaining > computerCardsRemaining)
        {
            winner = "Player wins"
        }
        else
        {
            winner = "Computer wins"
        }
    }
    
    func getGameNumber() -> Int
    {
        return gameNumber
    }
    
    func getRoundsPlayed() -> Int
    {
        return roundsPlayed
    }
    
    func getPlayerCardsRemaining() -> Int
    {
        return playerCardsRemaining
    }
    
    func getComputerCardsRemaining() -> Int
    {
        return computerCardsRemaining
    }
    
    func getwinner() -> String
    {
        return winner
    }
}
 
// Create an array to store leaderboard entries to be displayed later on 
var leaderboardEntries = [LeaderboardEntry]()

struct ContentView: View
{
    @State var gamesPlayed = 1
    @State var buttonPresses = 0
    @State var roundsPlayed = 0
    
    @State var playerCard = "green_back"
    @State var computerCard = "green_back"
    
    @State var playerCardCount = 0
    @State var computerCardCount = 0
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                VStack
                {
                    Text("Game: \(gamesPlayed) Round: \(roundsPlayed) / 10")
                }
                    
                HStack
                {
                    Text("Computer Cards: \(computerCardCount)")
                        .padding(.maximum(0, 10))
                    
                    Image(computerCard)
                        .resizable()
                        .scaledToFit()
                }
                
                HStack
                {
                    Image(playerCard)
                        .resizable()
                        .scaledToFit()
                    
                    Text("Player Cards: \(playerCardCount)")
                        .padding(.maximum(0, 20))
                }
                
                HStack
                {
                    Button(action:
                    {
                        if (buttonPresses == 0)
                        {
                            createShuffledDeck()
                            splitIntoTwoDecks()
                            
                            playerCard = getPlayerCardImage()
                            computerCard = getComputerCardImage()
                            
                            gameLogic()
                            
                            playerCardCount = playerDeck.count
                            computerCardCount = computerDeck.count
                            
                            buttonPresses = 1
                            roundsPlayed += 1
                        }
                        else if (roundsPlayed < 10)
                        {
                            playerCard = getPlayerCardImage()
                            computerCard = getComputerCardImage()
                            
                            gameLogic()
                            
                            playerCardCount = playerDeck.count
                            computerCardCount = computerDeck.count
                            
                            roundsPlayed += 1
                        }
                    })
                    {
                        Text("Deal Cards")
                    }
                    .font(.title2)
                    .padding(.maximum(0, 10))
                    .foregroundColor(.white)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Button(action:
                    {
                        let leaderboardOne = LeaderboardEntry(gameNumber: gamesPlayed, roundsPlayed: roundsPlayed, playerCardsRemaining: playerCardCount, computerCardsRemaining: computerCardCount)
                        
                        leaderboardEntries.append(leaderboardOne)
                        
                        gamesPlayed += 1
                        
                        buttonPresses = 0
                        roundsPlayed = 0
                        
                        playerCard = "green_back"
                        computerCard = "green_back"
                        
                        playerCardCount = 0
                        computerCardCount = 0
                        
                        playerDeck.removeAll()
                        computerDeck.removeAll()
                    })
                    {
                        Text("End Game")
                    }
                    .font(.title2)
                    .padding(.maximum(0, 10))
                    .foregroundColor(.white)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.maximum(0, 10))
                
                HStack
                {
                    NavigationLink(destination: LeaderBoardView())
                    {
                        Text("Leaderboards")
                    }
                    .font(.title2)
                    .padding(.maximum(0, 10))
                    .foregroundColor(.white)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

struct LeaderBoardView: View
{
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                ForEach(leaderboardEntries)
                { entry in
                    VStack
                    {
                        Text("--------------------------------------")
                        Text("Game Number: \(entry.getGameNumber())")
                        Text("Rounds Played: \(entry.getRoundsPlayed())")
                        Text("Player Ending Cards: \(entry.getPlayerCardsRemaining())")
                        Text("Computer Ending Cards: \(entry.getComputerCardsRemaining())")
                        Text("Game Result: \(entry.getwinner())")
                        Text("--------------------------------------")
                    }
                }
            }
        }
    }
}
