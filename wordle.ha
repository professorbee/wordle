use bufio;
use fmt;
use fs;
use io;
use os;
use types;
use math::random;
use time;
use strings;

export fn main() void = {
	const current_time = time::now(time::clock::REALTIME).sec;
	const randgen = random::init(current_time: u64);
	let lineNum: uint = 0;
	const wordlist = match (os::open("words.txt")) {
	case let file: io::file =>
    		yield file;
    	case let err: fs::error =>
        	fmt::fatalf("Error opening word list: {}",
			fs::strerror(err));
	};
 	defer io::close(wordlist)!;

	// This leaks, but when I try to free it, there's an error.
	// I don't know how to fix it. Too bad!
	let words: []str = [];

	const scan = bufio::newscanner(wordlist, types::SIZE_MAX);
	for (let i = 0u; true; i += 1) {
		const line = match (bufio::scan_line(&scan)!) {
		case io::EOF =>
    			lineNum = i;
    			break;
    		case let line: const str =>
        		yield line;
		};
		append(words, line);
	};
	const randomWordIndex = random::u64n(&randgen, lineNum: u64);
	const randomWord = words[randomWordIndex];
	// This is not how you're meant to free this!!
	free(words);
	fmt::printfln("{}", randomWord)!;
};
