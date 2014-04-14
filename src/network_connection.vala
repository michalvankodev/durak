public class Network_connection : Object {
	public Player player {get; set;}
	public SocketConnection connection {get; set;}
	public int id {get; set; default = 0;}
	
	public Network_connection(Player _player, SocketConnection _conn, int _id = 0) {
		this.player = _player;
		this.connection = _conn;
		this.id = _id;
	}
}
