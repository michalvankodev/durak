public abstract class Network : Object {
	public bool connected {get; set; default = false;}
	public Player main_player {get; set;}
	public List<Player> connected_players;
	public signal void on_message_sent(bool success);
	public signal void on_message_received();
	public signal void new_player_connected(Player player);
	
	public bool is_on_turn(Player player) {
		return false;
	}
	
	public abstract Player? add_player(Player player);
}
