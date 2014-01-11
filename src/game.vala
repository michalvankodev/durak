public class Game : Object {
	private Player[] players;
	private Deck deck;
	private Discard_pile discard_pile;
	private Card.Card_type trump;
	private Player player_on_turn;
	private States state;
	
	private enum States {
		ATTACK,
		DEFENSE,
		SECOND_ATTACK,
		FIGURING
	}
	
	public int turn;
	
	public Game(int number_of_players) {
		this.turn = 0;
		this.players = new Player[number_of_players];
		this.deck = new Deck();
		
		this.start_game();
	}
	
	private void start_game() {
		this.state = States.FIGURING;
		this.deal_deck();
		this.trump = this.select_trump();
		
		this.choose_attacker();
		this.next_turn();
	}
	
	private void deal_deck() {
		for (int no_cards = 0; no_cards < 6; no_cards++) {
			for (int i = 0; i < this.players.length; i++) {
				this.players[i].take_card(this.deck.push_card());
			}
		}
	}
	
	private Card.Card_type select_trump() {
		Card trump_card = this.deck.push_card();

		this.deck.insert_trump(trump_card);
		return trump_card.card_type;
		
	}
}