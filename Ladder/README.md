# Ladder

梯子

A solution for the IWE (Immersive Wallless Experience) on iOS platform.

Keep in mind:

> The scenery outside the wall is beautiful and dangerous.

## Features

* Hide VPN Icon
* PAC (Proxy auto-config)
	* Default URL: [https://git.io/gfwpac](https://git.io/gfwpac)
		* Powered by [GFWPAC](https://github.com/sheng/gfwpac)
		* Default proxies (will try in order):
			* `SOCKS5 127.0.0.1:1081`
			* `SOCKS 127.0.0.1:1081`
			* `SOCKS5 127.0.0.1:1080`
			* `SOCKS 127.0.0.1:1080`
			* `DIRECT`
		* Almost no risk of being blocked (hosted on GitHub)
	* Recommended URL: [https://aofei.org/pac](https://aofei.org/pac)
		* Powered by [Aofei ['ɔ:fei]](https://aofei.org)
		* Default proxies (will try in order):
			* `SOCKS5 127.0.0.1:1080`
			* `SOCKS 127.0.0.1:1080`
			* `DIRECT`
		* Custom proxies support:
			* `https://aofei.org/pac?proxies=SOCKS5+127.0.0.1%3A1081`
			* `https://aofei.org/pac?proxies=DIRECT`
		* HTTP caching support (`max-age` is 3600)
* Shadowsocks
	* Powered by [NEKit](https://github.com/zhuhaow/NEKit)
	* Multiple methods support:
		* `AES-128-CFB`
		* `AES-192-CFB`
		* `AES-256-CFB` **(RECOMMENDED)**
		* `ChaCha20`
		* `Salsa20`
		* `RC4-MD5`

## Requirements

* iOS 9.3+
* Xcode 9.3+
* [Apple Developer Program](https://developer.apple.com/programs)
* [Carthage](https://github.com/carthage/carthage)

## Installation

1. Check out the latest version of the project:

```bash
$ git clone https://github.com/sheng/ladder-ios.git
```

2. Enter the project directory, check out the project's dependencies:

```bash
$ cd ladder-ios
$ carthage update --no-use-binaries --platform ios
```

3. Open the `Ladder.xcodeproj`.

4. Build and run the `Ladder` scheme.

5. Enjoy yourself.

## Community

If you want to discuss this project, or ask questions about it, simply post
questions or ideas [here](https://github.com/sheng/ladder-ios/issues).

## Contributing

If you want to help build this project, simply send pull requests
[here](https://github.com/sheng/ladder-ios/pulls).

## TODOs

* [x] Provide an option to store PAC during configuration
* [ ] No longer rely on the [NEKit](https://github.com/zhuhaow/NEKit) to
implement the Shadowsocks protocol
* [ ] Stop tunnel when authentication fails
* [ ] Add support for more Shadowsocks methods
* [ ] Add support for IPv6

## License

This project is licensed under the Unlicense.

License can be found [here](LICENSE).
