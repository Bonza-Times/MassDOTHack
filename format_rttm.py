"""
Take formatted data from MassDOT API and apply that information to raw data
in MySQL. Can use the lat/long for mapping road speeds, etc.

MassDOT API:
http://www.massdot.state.ma.us/feeds/traveltimes/RTTM_feed.aspx
"""
print(__doc__)

import sys
import MySQLdb

# connect to the MySQL server:
try:
    conn = MySQLdb.connect (host = "massdot_bluetoad_data",
                            user = "tableau",
                            passwd = "Timber",
                            db = "blued")
except MySQLdb.Error, e:
    print "Error %d: %s" % (e.args[0], e.args[1])
    sys.exit (1)

# deal with xml

"""
Going to just visualize using the API. If that's working then I'll convert
the raw data to give us more insight.
"""
