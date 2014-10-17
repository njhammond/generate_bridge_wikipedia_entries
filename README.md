generate_bridge_wikipedia_entries
=================================

Automatically generate the Bridge accomplishments entries for Duplicate Bridge players in Wikipedia.

Given a set of CSV files that contains a list of awards, honors, winners from Bridge events, the script generates the Bridge accomplishments for each player.

See the players directory for a list of current output.

Install
==

Download this Git.


Run
==

    ruby parse_winners.rb


Output
==

The directory ./players contains information on each player in the standard Wikipedia format for duplicate bridge players. A copy of this has been checked in.

Set up
==

The file winners.csv contains the list of winners/runners-up from ACBL events. The various other *.csv files contain information about different events/awards, e.g. ACBL Hall of Fame, World Open Pairs, Bermuda Bowl etc. These files need to be kept up to date.

Known Issues
==

#### GIGO

Garbage In Garbage Out (GIGO) applies. If the original data is wrong, so is the output.
Some of the data came from the ACBL web site. If they have wrong data, it is GIGO.

Example: Larry Cohen, Larry T. Cohen, Larry N. Cohen are all listed as NABC winners on the ACBL web site. The last two are unique. The "Larry Coohen" is ambiguous. Unfortunately this software does not know the difference between these 3 entries.

#### Married/Divorced Names

If someone wins different titles with different names, they are not merged.

Known examples:

  * Kitty Munson/Cooper/Bethe
  * Edith Frelich/Kemp/Seligman
  * Kerri Shuman/Sanborn

This will have to be a manual fix.

#### ACBL/US Centric
The code is ACBL centric/US centric. If someone wants to create something similar for another National Bridge Organization (NBO), go for it.

#### Missing Data
There is still some missing data, for example, a mapping from name to a WBF ID would be helpful.

#### Missing Awards/Events
There is still some missing events/awards, for example Cavendish, IBPA awards, dOrsi Bowl, Venice Cup.

Upkeep
==

The file events.csv contains a list of all events that are processed, along with a URL that has the information where the data was extracted.

As a new event occurs, the URL information should be updated in events.csv. As a better reference becomes available, we should use that.

The file winners.csv is generated from an Excel file. I have checked in a copy, to make it easier for others to run, but do not make any edits to it. These will be lost when a new version is generated.

Automatically Generate Links
==

To automatically edit a Wikipedia page of Bridge players, and add links to players' names, use the add_links.rb script.

Create a file input.txt that contains the data to edit, e.g. the Winners section from the Blue Ribbons.

		cat > input.txt
		# Paste in data from Winners section of a Wikipedia entry
    ruby add_links.rb

The file output.txt contains the replacement text. Before replacing, I suggest comparing the two files

    diff input.txt output.txt

Be careful. This tool makes no distinction between "Charles Coon" the bridge player, and the two other Charles Coon entries on Wikipedia. Edit the file conversion_list.txt before running the add_ilnks.rb script if needed.

Example
==

Download Git

    ruby parse_winners.rb
		cd players
		cat Lew\ Stansby
		# Go to Wikipedia. Look at entries under "Bridge accomplishments"
		# Edit the entry
		# Cut/paste the contents to Wikipedia

Copyright
==

The original data is public, i.e. on the Internet. I have done nothing more than collect that information and put it in a spreadsheet.

License
==

All of this under the MIT License. See LICENSE.
