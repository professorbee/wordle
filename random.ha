use bufio;
use fmt;
use math::random;
use time;

export fn main() void = {
	const current_time = time::now(time::clock::REALTIME).sec;
	const randgen = random::init(current_time: u64);
	fmt::printfln("{}", random::u64n(&randgen, 100))!;
};
