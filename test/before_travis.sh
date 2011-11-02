# Create a database.yml for the right database
echo "Setting up database.yml for $DB"
cp "test/files/database.yml.$DB" "test/dummy/config/database.yml"

# Set up database
echo "Creating databases for $DB and loading schema"
cd "test/dummy"
bundle exec rake db:create
bundle exec rake db:test:prepare
bundle exec rake db:fixtures:load
