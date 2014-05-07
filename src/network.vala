public abstract class Network : Object {
	public bool connected {get; set; default = false;}
	public Player main_player {get; set;}
	public int connection_id {get; set;}
	
	public List<Player> playing_players;
	
	public signal void on_message_sent(string message);
	public signal void on_message_recieved(string message);
	
	public signal void new_player_connected(Player player);
	public signal void game_started();
	
	
	public bool is_on_turn(Player player) {
		return false;
	}
	
	public abstract bool add_player(Player player);
	public abstract void add_new_connection(string player_info, SocketConnection conn);
	
	protected void process_message(string message, SocketConnection? conn = null) {
		int split_index = message.index_of(" "); 
		string action = message.substring(0, split_index);
		string content = message.substring(split_index + 1);
		
		switch(action) {
		case "new_connection" :
			this.add_new_connection(content, conn);
			break;
		case "add_player" :
			//this.add_player(content, conn);
			//this.send_connected_players();
			break;
		default:
			stdout.printf("Unknown action " + action +" requested\n");
			break;
		}
	}
}
