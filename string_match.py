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

def clean_string(string_list):
    """ Tokenize each stop and remove 'line'

    Args:
        string_list: list of strings
    Returns:
        List of lists where each item in the list is a tokenized form
        of the list item which was inputted, stop words etc. are
        removed.
    """
    clean_list = []
    drop_set = {"Line","line","Branch", "branch", \
                "Main", "main", "Route", "route", \
                "Via", "Br.Via", "x"}
    for item in string_list:
        list_items = item.split(" ")
        clean_tokens = []
        for token in list_items:
            if token in drop_set:
                pass
            else:
                clean_tokens.append(token)
        clean_list.append(clean_tokens)
    return clean_list

def similarity(word_list, similar_word_list):
    """ How similar are word lists?

    Matches on letter, does not care about
    order.

    Args:
        word_list: List that you want matched
        similar_word_list: How similar are words in this list?

    Returns:
        Ranked list of tuples
    """
    # letter count of word_list
    letter_dict = {}
    for letter in word:
        letter_dict[letter] = True
        for char in sim_word:
            counter = 0
            if char in letter_dict:
                letter_dict[letter] = counter + 1
    return letter_dict
    
        

longer_list = clean_string(longer_list)
shorter_list = clean_string(shorter_list)
    
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
            sim_score = similarity(place_holder)
            ranking.append((term, sim_score))
        ranking = reverse(ranking, key=lambda x:x[1])
        match_dict[item] = ranking
    return match_dict



            
        
        
    
