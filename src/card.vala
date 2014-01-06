public class Card : Object {
	
	private int card_value;
	private C_type card_type;
	
	public enum C_type {
		HEARTS,
		DIAMONDS,
		SPADES,
		CLUBS;
		
		public string to_string() {
			switch (this) {
				case SPADES:
					return "Spades";

				case HEARTS:
					return "Hearts";

				case DIAMONDS:
					return "Diamonds";

				case CLUBS:
					return "Clubs";

				default:
					assert_not_reached();
			}
		}
	}
	
	public Card(int _card_value, C_type _card_type) {
		this.card_value = _card_value;
		this.card_type = _card_type;
	}
	
	public string to_string() {
		return this.transfer_card_value() + " of " + this.card_type.to_string();
	}
	
	public string to_short_string() {
		return this.transfer_card_value() + this.card_type.to_string()[0].to_string().down();
	}
	
	private string transfer_card_value() {
		if (this.card_value > 10) {
			char corresponding_char = (char) this.card_value + 54 ;
			return corresponding_char.to_string();
		}
		return this.card_value.to_string();
	}
	
	
}