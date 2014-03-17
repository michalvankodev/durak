public abstract class Network : Object {
	public bool connected {get; set; default = false;}
	public Player main_player {get; set;}
	public List<Player> connected_players;
	
	public bool is_on_turn(Player player) {
		return false;
	}
	
	public abstract Player? add_player(Player player);
}