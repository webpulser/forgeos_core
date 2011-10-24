# Create a database.yml for the right database
echo "Setting up database.yml for $DB"
cp "test/database.yml.$DB" "test/dummy/config/database.yml"

# Set up database
echo "Creating databases for $DB and loading schema"
cd "test/dummy"
bundle exec rake db:create
bundle exec rake db:schema:load