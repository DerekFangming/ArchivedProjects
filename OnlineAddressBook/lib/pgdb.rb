# Ruby script that provides functions to connect to
# a PostgreSQL database
#
# ‘pg’ is a PostgreSQL connector for Ruby
require 'pg'
#
# this function creates and returns a connection
# to the given database using dbPath
#
def connectToDB(dbPath)
    # Parse the path in the form:
    #   postgres://user:pass@hostname:port/dbname
    dbPath =~ %r|^postgres://(\S*):(\S*)@(\S*):(\d*)/(\S*)$|
     # Fill in with parsed fields
    PG::Connection.new(:host => $3, :port => $4, \
      :dbname => $5, :user => $1, :password => $2)
end
#
# this function asks for a connection and returns a
# success string if the connection is obtained
#
def testDBConnection(dbPath)
connectToDB(dbPath)
'Connected successfully!'
end
#
# this function displays the SQL input form if no parameters
# are given, otherwise it connects to the database, executes
# the provided SQL and returns some HTML containing the results
#
def runDBShell (dbPath, params=nil)
if (params == nil)
<<EOS
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>Database Manager</title>
</head>
<body>
<h1>Enter SQL statements in the box below.</h1>
<form method="post">
<textarea name="sqlCode" rows="20" cols="150"></textarea><br /><br />
<input type="submit" value="Submit">
</form>
</body>
</html>
EOS
else
conn = connectToDB(dbPath) # connect to the database
results =conn.exec(params[:sqlCode]) # execute the SQL contained in params
strOut = ''
results.each do |row| # loop through the result of the SQL query
row.each do |column|
strOut = strOut + ' ' + column.to_s # append to result string
end
end
strOut + '<br /><br /><br /><a href="/db_manager">Enter another query</a>'
end
end