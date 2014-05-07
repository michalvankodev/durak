public class Network_connection : Object {
	public Player player {get; set;}
	public int id {get; set; default = 0;}
	public Network_worker worker;
	
	public Network_connection(SocketConnection _conn, int _id = 0) {
		this.id = _id;
		this.worker = new Network_worker(_conn);
		this.worker.create.begin(this.id);
		stdout.printf("worker creted\n");
	}
	
	public void send(string message) {
		this.worker.send_message.begin(message);
	}
}
