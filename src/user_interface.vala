public interface user_interface : Object {
	
	public abstract void start_new_game(int players);
	public abstract void display_menu();
	
	// Things to show
	public abstract void show_player_cards();
	public abstract void show_table_cards();
	
	
	public abstract void play_card(Card card);
	
}