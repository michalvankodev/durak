public class Network : Object {
	public bool connected {get; set; default = false;}
	public Player main_player {get; set;}
	public Player[] connected_players {get; set;}
}