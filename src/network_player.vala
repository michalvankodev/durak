public class Network_player : Player {
	public string address {get; set;}
	public SocketConnection connection {get; set;}
	public int id {get; set;}
	
	public Network_player(string name) {
		base(name);
	}
}
