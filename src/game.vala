public class Game : Object {
	private Player[] players;
	private Stack stack;
	private Discard_pile discard_pile;
	private Card.C_type trump;
	
	private enum state {
		ATTACK,
		DEFENSE,
		SECOND_ATTACK,
		FIGURING
	}
	
	public int turn;
	
}