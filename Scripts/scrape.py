import os
import plistlib
import urllib2
import json
from BeautifulSoup import BeautifulSoup
from io import open

json_str = open(os.getcwd() + '/emojis.json').read()
associations = json.loads(json_str)

url = 'http://unicode.org/emoji/charts/full-emoji-list.html'
page = urllib2.urlopen(url)
soup = BeautifulSoup(page.read())
raw = {}
trs = soup.findAll('tr', limit = None)

for tr in trs[1:]:
	emoji = tr.find('td', { 'class' : 'chars' } ).getText()
	attributes = tr.findAll('td', { 'class' : 'name' } )[1].getText().split(",")
	for entry in associations:
		try:
			if associations[entry]["char"] == emoji:
				for element in associations[entry]["keywords"]:
					if element not in attributes:
						attributes.append(element)
		except:
			pass
	raw[emoji] = attributes
results = {}
for key, words in raw.items():
	for word in words:
		if word == '':
			continue
		if word not in results:
			results[word] = [key]
		else:
			results[word].append(key)
with open(os.getcwd() + '/Keywords.plist', 'wb') as file:
    plistlib.writePlist(results, file)