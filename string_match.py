import csv
from difflib import SequenceMatcher

# csv with names
names1 = "/home/tyler/code/MassDOTHack/shared_data/names1.csv"
names2 = "/home/tyler/code/MassDOTHack/shared_data/names2.csv"

def open_csv_file(csv_file):
    """ Open csv file """
    name_list = []
    with open(csv_file, 'rb') as csvfile:
        station_finder = csv.reader(csvfile, delimiter=',')
        for row in station_finder:
            name_list.append(row)
        return name_list


name_list1 = open_csv_file(names1)
name_list2 = open_csv_file(names2)

print len(name_list2), "name_list2"
print len(name_list1), "name_list1"

longer_list = [item[1] for item in name_list2]
shorter_list = [item[1] for item in name_list1]


def match_strings(longer_list, shorter_list):
    """ Find similarities between list

    We're going to see which elements in the shorter list
    are most similar to elements in the longer list. Those
    with no similarities are given a 0.

    Args:
        longer_list: list of lists from csv read
        shorter_list: list of lists from csv read

    Returns:
        Dictionary with keys mapped to longer_list. Values
        are a list of tuples with shorter_list name and
        diff similarity score.
    """
    match_dict = {}
    for item in longer_list:
        ranking = []
        for term in shorter_list:
            sim_score = SequenceMatcher(None, item, term).ratio()
            ranking.append((term, sim_score))
        ranking = reverse(ranking, key=lambda x:x[1])
        match_dict[item] = ranking
    return match_dict



            
        
        
    
