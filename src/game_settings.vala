public class Game_settings : Object {
	public string player_name {get; set;}
	
	public Game_settings.create_file() {
		this.player_name = "Player";
		this.save();
	}
	
	public void save() {
		string data = Json.gobject_to_data(this, null);
		stdout.printf(this.player_name+"<-- "+ " \n \n " +data);
		try {
			FileUtils.set_contents("settings.json", data);
			
		} catch (Error e) {
			stdout.printf("Error %s\n", e.message);
		}
	}
	public static Game_settings? load() {
		try {
			string filepath = "settings.json";
			if (FileUtils.test(filepath, FileTest.EXISTS)) {
				stdout.printf("file exist");
				string content;
				FileUtils.get_contents(filepath, out content);
				return Json.gobject_from_data(typeof(Game_settings), content) as Game_settings;
			}
			else {
				stdout.printf("creating new file");
				Game_settings new_settings = new Game_settings.create_file();
				return new_settings;
			}
		} catch (Error e) {
			stdout.printf("Error %s\n", e.message);
			return null;
		} 
	}
}