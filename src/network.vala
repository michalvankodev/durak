public abstract class Network : Object {
	public bool connected {get; set; default = false;}
	public Network_player main_player {get; set;}
	//public int main_player_id {get; set;} // Gained from HOST 
	public List<Network_player> connected_players; // Key = players_id
	public signal void on_message_sent(bool success);
	public signal void on_message_received();
	public signal void new_player_connected(Player player);
	public signal void game_started();
	
	public bool is_on_turn(Player player) {
		return false;
	}
	
	public abstract bool add_player(Player player);
	public abstract void process_connected_player(string player_info, SocketConnection conn);
	
	protected void process_message(string message, SocketConnection? conn = null) {
		int split_index = message.index_of(" "); 
		string action = message.substring(0, split_index);
		string content = message.substring(split_index + 1);
		
		switch(action) {
		case "add_player" :
			this.process_connected_player(content, conn);
			//this.send_connected_players();
			break;
		default:
			stdout.printf("Unknown action " + action +" requested\n");
			break;
		}
	}
}
