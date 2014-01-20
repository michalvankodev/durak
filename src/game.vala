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
		
		this.player_on_turn = this.choose_first_attacker();
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
		return trump_card.type;
		
	}
	
	/*
	 * This function will consider rule about lowest trump_card of the each player.
	 */
	
	private Player choose_first_attacker() {
		Player with_lowest_trump_card;
		
		this.players.foreach((player) => {
			if (player.get_lowest_trump_card(this.trump)) {
				
				if (!with_lowest_trump_card) 
					with_lowest_trump_card = player;
				
				else if(player.get_lowest_trump_card(this.trump).value < with_lowest_card.get_lowest_trump_card(this.trump).value)
					with_lowest_trump_card = player;
			}
		});
		
		if (!with_lowest_trump_card) {
			with_lowest_trump_card = this.players[Random.next_int(0,this.players.length())];
		}
		
		return with_lowest_trump_card;
	}
}