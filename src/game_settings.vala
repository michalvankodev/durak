public class Game_settings : Object {
	private string player_name;
	
	public void save() {
		string data = Json.gobject_to_data(this, null);
		
		try {
			File file = File.new_for_path("settings.json");
			FileOutputStream stream = file.replace(null,false,FileCreateFlags.NONE);
			stream.write(data.data, null);
			
		} catch (Error e) {
			stdout.printf("Error %s\n", e.message);
		}
	}
}