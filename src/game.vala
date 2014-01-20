public class Game : Object {
	private Player[] players;
	private Deck deck;
	private List<Card> discard_pile;
	private List<Card> cards_on_table
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
		this.state = ATTACK;
	}
	
	private void attack_with(Player attacker, Card card){
		cards_on_table.append(card);
		attacker.play_card(card);
		this.state = DEFENSE;
	}
	
	private void defend_with(Player defender, Card card){
		cards_on_table.append(card);
		defender.play_card(card);
		this.state = SECOND_ATTACK;
	}
	
	private void take_cards_from_table(Player receiver) {
		this.state = FIGURING;
		
		this.cards_on_table.foreach((card) => {
			cards_on_table.remove(card);
			receiver.take_card(card);
		});
		this.state = ATTACK;
	}
	
	private void pass_second_attack(){
		this.state = FIGURING;
		
		this.discard_cards_on_table();
		
	}
	
	private void discard_cards_on_table() {
		this.cards_on_table.reverse();
		
		this.cards_on_table.foreach((card) => {
			this.cards_on_table.remove(card);
			this.discard_pile.append(card));
		});
		this.state = ATTACK;
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
		
		foreach(Player player in this.players){
			if (player.get_lowest_trump_card(this.trump) != null) {
				
				if (with_lowest_trump_card == null) 
					with_lowest_trump_card = player;
				
				else if(player.get_lowest_trump_card(this.trump).value < with_lowest_trump_card.get_lowest_trump_card(this.trump).value)
					with_lowest_trump_card = player;
			}
		}
		
		if (with_lowest_trump_card == null) {
			with_lowest_trump_card = this.players[Random.int_range(0,this.players.length)];
		}
		
		return with_lowest_trump_card;
	}
}