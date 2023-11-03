import praw
import random

# Define Reddit instance
reddit = praw.Reddit(
    client_id="6qYF2dS6-_xtR4SdVtZMAg",
    client_secret="XGJnXqVGGLwluxOkKBV4x1uBdMiBzQ",
    user_agent="Artistic_Bit76",
)

# Get subreddits function (define below)
def subreddit_variables(name):
    return reddit.subreddit(f"{name}")

# Get x amount of subreddit posts from top, sorted by year
def random_posts_collection(subreddit_list, limit):
    posts = {}
    for subreddit in subreddit_list:
        posts[f"{subreddit}"] = []
        for submission in subreddit.top(time_filter = 'year', limit = limit):
            posts[f"{subreddit}"].append("https://reddit.com/" + submission.permalink)

    return posts

# Make a random URL generator
def select_posts(dictionary, number_of_posts):
    randomized_posts = {}
    random_numbers = []
    for subreddit in dictionary:
        randomized_posts[subreddit] = []
        for number in range(0, number_of_posts):
            random_numbers.append(random.randint(0, len(dictionary[subreddit])-1))
        for index in random_numbers:
            randomized_posts[subreddit].append(dictionary[subreddit][index])
            random_numbers = []
    return randomized_posts

# Export links into a .txt
def create_txt_file(sub_name, text_name, dictionary):
    with open(f"{text_name, sub_name}.txt", "w") as file:
        for post in dictionary[sub_name]:
            file.write(f"{post}" + "\n")

# Define subreddits
funny = subreddit_variables("funny")
Gaming = subreddit_variables("Gaming")
Ask_Reddit = subreddit_variables("AskReddit")

# Make selection pool from which will be randomly selected (10k posts)
collection = random_posts_collection([funny, Gaming, Ask_Reddit], 100000)

# Make a selection of 80 for each coder
I_G_selection = select_posts(collection, 80)
H_G_selection = select_posts(collection, 80)
O_C_selection = select_posts(collection, 80)
A_M_selection = select_posts(collection, 80)
test_selection = select_posts(collection, 80)

#print(selection)             # Check

create_txt_file("Gaming", "test_sample", test_selection)        #create txt for each coder:
create_txt_file("funny", "test_sample", test_selection)         # 1. Select subreddit, 2. Specify File name,
create_txt_file("AskReddit", "test_sample", test_selection)     # 3. Specify a selection

#MÜLL###################################################################################################################
#sub_button("funny", 1)
#sub_button("Gaming", 2)
#sub_button("AskReddit", 3)
#root.mainloop()

# Random click
#def button_press(name):
    #webbrowser.open(random.choice(selection[name]))

# Make button
#def sub_button(name, button_count):
    #button = tkinter.Button(frame, text=f"{name}", command = lambda: button_press(name))
    #button.grid(column=button_count,row=0)
    #return

import tkinter
import urllib
import webbrowser

#root = tkinter.Tk()
#frame = tkinter.Frame(root)
#frame.grid()