pragma solidity ^0.5.8;

interface TubInterface {
    function open() external returns (bytes32);
    function join(uint) external;
    function exit(uint) external;
    function lock(bytes32, uint) external;
    function free(bytes32, uint) external;
    function draw(bytes32, uint) external;
    function wipe(bytes32, uint) external;
    function give(bytes32, address) external;
    function shut(bytes32) external;
    function cups(bytes32) external view returns (address, uint, uint, uint);
    function gem() external view returns (TokenInterface);
    function gov() external view returns (TokenInterface);
    function skr() external view returns (TokenInterface);
    function sai() external view returns (TokenInterface);
    function ink(bytes32) external view returns (uint);
    function tab(bytes32) external returns (uint);
    function rap(bytes32) external returns (uint);
    function per() external view returns (uint);
    function pep() external view returns (PepInterface);
}

interface TokenInterface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function deposit() external payable;
    function withdraw(uint) external;
}

interface PepInterface {
    function peek() external returns (bytes32, bool);
}

interface UniswapExchange {
    function getEthToTokenOutputPrice(uint256 tokensBought) external view returns (uint256 ethSold);
    function getTokenToEthOutputPrice(uint256 ethBought) external view returns (uint256 tokensSold);
    function tokenToTokenSwapOutput(
        uint256 tokensBought,
        uint256 maxTokensSold,
        uint256 maxEthSold,
        uint256 deadline,
        address tokenAddr
    ) external returns (uint256  tokensSold);
    function ethToTokenSwapOutput(uint256 tokensBought, uint256 deadline) external payable returns (uint256  ethSold);
}

interface UniswapFactoryInterface {
    function getExchange(address token) external view returns (address exchange);
}

interface MCDInterface {
    function swapDaiToSai(uint wad) external;
    function migrate(bytes32 cup) external returns (uint cdp);
}

interface PoolInterface {
    function accessToken(address[] calldata ctknAddr, uint[] calldata tknAmt, bool isCompound) external;
    function paybackToken(address[] calldata ctknAddr, bool isCompound) external payable;
}

interface OtcInterface {
    function getPayAmount(address, address, uint) external view returns (uint);
    function buyAllAmount(
        address,
        uint,
        address,
        uint
    ) external;
}

interface GemLike {
    function approve(address, uint) external;
    function transfer(address, uint) external;
    function transferFrom(address, address, uint) external;
    function deposit() external payable;
    function withdraw(uint) external;
}

interface JugLike {
    function drip(bytes32) external;
}

interface ManagerLike {
    function cdpCan(address, uint, address) external view returns (uint);
    function ilks(uint) external view returns (bytes32);
    function owns(uint) external view returns (address);
    function urns(uint) external view returns (address);
    function vat() external view returns (address);
    function open(bytes32) external returns (uint);
    function give(uint, address) external;
    function cdpAllow(uint, address, uint) external;
    function urnAllow(address, uint) external;
    function frob(uint, int, int) external;
    function frob(
        uint,
        address,
        int,
        int
    ) external;
    function flux(uint, address, uint) external;
    function move(uint, address, uint) external;
    function exit(
        address,
        uint,
        address,
        uint
    ) external;
    function quit(uint, address) external;
    function enter(address, uint) external;
    function shift(uint, uint) external;
}

interface VatLike {
    function can(address, address) external view returns (uint);
    function ilks(bytes32) external view returns (uint, uint, uint, uint, uint);
    function dai(address) external view returns (uint);
    function urns(bytes32, address) external view returns (uint, uint);
    function frob(
        bytes32,
        address,
        address,
        address,
        int,
        int
    ) external;
    function hope(address) external;
    function move(address, address, uint) external;
}

interface GemJoinLike {
    function dec() external returns (uint);
    function gem() external returns (GemLike);
    function join(address, uint) external payable;
    function exit(address, uint) external;
}

interface GNTJoinLike {
    function bags(address) external view returns (address);
    function make(address) external returns (address);
}

interface DaiJoinLike {
    function vat() external returns (VatLike);
    function dai() external returns (GemLike);
    function join(address, uint) external payable;
    function exit(address, uint) external;
}


contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        z = x - y <= x ? x - y : 0;
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

}


contract Helpers is DSMath {

    /**
     * @dev get MakerDAO SCD CDP engine
     */
    function getSaiTubAddress() public pure returns (address sai) {
        sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
    }

    /**
     * @dev get Sai (Dai v1) address
     */
    function getSaiAddress() public pure returns (address sai) {
        sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
    }

    /**
     * @dev get Dai (Dai v2) address
     */
    // function getDaiAddress() public pure returns (address dai) {
    //     dai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
    // }

    /**
     * @dev get Compound WETH Address
     */
    function getWETHAddress() public pure returns (address wethAddr) {
        wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // main
    }

    /**
     * @dev get OTC Address
     */
    function getOtcAddress() public pure returns (address otcAddr) {
        otcAddr = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e; // main
    }

    /**
     * @dev get uniswap MKR exchange
     */
    function getUniswapMKRExchange() public pure returns (address ume) {
        ume = 0x2C4Bd064b998838076fa341A83d007FC2FA50957;
    }

    /**
     * @dev get uniswap factory
     */
    function getUniswapFactory() public pure returns (address addr) {
        addr = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
    }

    /**
     * @dev get InstaDApp Liquidity Address
     */
    function getPoolAddress() public pure returns (address payable liqAddr) {
        liqAddr = 0x1564D040EC290C743F67F5cB11f3C1958B39872A;
    }

    /**
     * @dev setting allowance if required
     */
    function setApproval(address erc20, uint srcAmt, address to) internal {
        TokenInterface erc20Contract = TokenInterface(erc20);
        uint tokenAllowance = erc20Contract.allowance(address(this), to);
        if (srcAmt > tokenAllowance) {
            erc20Contract.approve(to, uint(-1));
        }
    }

}


contract MKRSwapper is Helpers {

    function swapToMkrOtc(address tokenAddr, uint govFee) internal {
        TokenInterface mkr = TubInterface(getSaiTubAddress()).gov();
        uint payAmt = OtcInterface(getOtcAddress()).getPayAmount(tokenAddr, address(mkr), govFee);
        if (tokenAddr == getWETHAddress()) {
            TokenInterface weth = TokenInterface(getWETHAddress());
            weth.deposit.value(payAmt)();
        } else {
            require(TokenInterface(tokenAddr).transferFrom(msg.sender, address(this), payAmt), "Tranfer-failed");
        }
        setApproval(tokenAddr, payAmt, getOtcAddress());
        OtcInterface(getOtcAddress()).buyAllAmount(
            address(mkr),
            govFee,
            tokenAddr,
            payAmt
        );
    }

    function swapToMkrUniswap(address tokenAddr, uint govFee) internal {
        UniswapExchange mkrEx = UniswapExchange(getUniswapMKRExchange());
        address uniSwapFactoryAddr = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
        TokenInterface mkr = TubInterface(getSaiTubAddress()).gov();

        if (tokenAddr == getWETHAddress()) {
            uint ethNeeded = mkrEx.getEthToTokenOutputPrice(govFee);
            mkrEx.ethToTokenSwapOutput.value(ethNeeded)(govFee, uint(1899063809));
        } else {
            address buyTknExAddr = UniswapFactoryInterface(uniSwapFactoryAddr).getExchange(tokenAddr);
            UniswapExchange buyTknEx = UniswapExchange(buyTknExAddr);
            uint tknAmt = buyTknEx.getTokenToEthOutputPrice(mkrEx.getEthToTokenOutputPrice(govFee)); //Check thrilok is this correct
            require(TokenInterface(tokenAddr).transferFrom(msg.sender, address(this), tknAmt), "not-approved-yet");
            setApproval(tokenAddr, tknAmt, buyTknExAddr);
            buyTknEx.tokenToTokenSwapOutput(
                    govFee,
                    tknAmt,
                    uint(999000000000000000000),
                    uint(1899063809), // 6th March 2030 GMT // no logic
                    address(mkr)
                );
        }

    }

}


contract SCDResolver is MKRSwapper {

    function open() internal returns (bytes32 cup) {
        cup = TubInterface(getSaiTubAddress()).open();
    }

    function wipe(bytes32 cup, uint _wad, address payFeeWith) internal {
        if (_wad > 0) {
            TubInterface tub = TubInterface(getSaiTubAddress());
            TokenInterface dai = tub.sai();
            TokenInterface mkr = tub.gov();

            (address lad,,,) = tub.cups(cup);
            require(lad == address(this), "cup-not-owned");

            setAllowance(dai, getSaiTubAddress());
            setAllowance(mkr, getSaiTubAddress());

            (bytes32 val, bool ok) = tub.pep().peek();

            if (ok && val != 0) {
                // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
                uint mkrFee = rdiv(tub.rap(cup), tub.tab(cup)); // I had to split because it was showing error in remix.
                mkrFee = rmul(_wad, mkrFee);
                mkrFee = wdiv(mkrFee, uint(val));

                // swapToMkrUniswap(payFeeWith, mkrFee); //Uniswap
                swapToMkrOtc(payFeeWith, mkrFee); //otc
            }

            tub.wipe(cup, _wad);
        }
    }

    function free(bytes32 cup, uint ink) internal {
        if (ink > 0) {
            TubInterface(getSaiTubAddress()).free(cup, ink); // No need to convert PETH in WETH because we will directly lock PETH in split CDP
        }
    }

    function lock(bytes32 cup, uint ink) internal {
        if (ink > 0) {
            TubInterface tub = TubInterface(getSaiTubAddress());
            TokenInterface peth = tub.skr();

            (address lad,,,) = tub.cups(cup);
            require(lad == address(this), "cup-not-owned");

            setAllowance(peth, getSaiTubAddress());
            tub.lock(cup, ink);
        }
    }

    function draw(bytes32 cup, uint _wad) internal {
        if (_wad > 0) {
            TubInterface tub = TubInterface(getSaiTubAddress());
            tub.draw(cup, _wad);
        }
    }

    function setAllowance(TokenInterface _token, address _spender) private {
        if (_token.allowance(address(this), _spender) != uint(-1)) {
            _token.approve(_spender, uint(-1));
        }
    }

}


contract MCDResolver is SCDResolver {
    function migrateToMCD(
        address payable scdMcdMigration,    // Migration contract address
        bytes32 cup,                        // SCD CDP Id to migrate
        address payGem                     // Token address (only if gov fee will be paid with another token)
    ) internal returns (uint cdp)
    {
        TubInterface tub = TubInterface(getSaiTubAddress());
        tub.give(cup, address(scdMcdMigration));

        // Get necessary MKR fee and move it to the migration contract
        (bytes32 val, bool ok) = tub.pep().peek();
        if (ok && uint(val) != 0) {
            // Calculate necessary value of MKR to pay the govFee
            uint govFee = wdiv(tub.rap(cup), uint(val));

            if (payGem != address(0)) {
                swapToMkrOtc(payGem, govFee);
            } else {
                require(tub.gov().transferFrom(msg.sender, address(this), govFee), "transfer-failed"); // Check Samyak - We can directly transfer MKR to address(scdMcdMigration). Right?
            }
            require(tub.gov().transfer(address(scdMcdMigration), govFee), "transfer-failed");
        }
        // Execute migrate function
        cdp = MCDInterface(scdMcdMigration).migrate(cup);
    }

    function shiftCDP( // Check Thrilok - in build function.
        address manager,
        uint cdpSrc,
        uint cdpOrg
    ) internal
    {
        ManagerLike(manager).shift(cdpSrc, cdpOrg);
    }
}


contract LiquidityResolver is MCDResolver {
    //Had to write seprate for pool, remix was showing error.
    function getLiquidity(uint _wad) internal {
        uint[] memory _wadArr = new uint[](1);
        _wadArr[0] = _wad;

        address[] memory addrArr = new address[](1);
        addrArr[0] = address(0);

        // Get liquidity assets to payback user wallet borrowed assets
        PoolInterface(getPoolAddress()).accessToken(addrArr, _wadArr, false);
    }

    function paybackLiquidity(uint _wad) internal {
        address[] memory addrArr = new address[](1);
        addrArr[0] = address(0);

        require(TokenInterface(getSaiAddress()).transfer(getPoolAddress(), _wad), "Not-enough-dai");
        PoolInterface(getPoolAddress()).paybackToken(addrArr, false);
    }
}


contract MigrateResolver is LiquidityResolver {

    event LogMigrate(uint scdCdp, uint toConvert, address payFeeWith, uint mcdCdp);
    event LogMigrateAndMerge(uint scdCdp, uint toConvert, address payFeeWith, uint mcdMergeCdp);

    function migrate(
        uint scdCDP,
        uint mergeCDP, //for merge
        uint toConvert,
        address payFeeWith,
        address payable scdMcdMigration,
        address manager, // Check Thrilok - will remove in the last, when we get final address
        address daiJoin // Check Thrilok - will remove in the last, when we get final address
    ) external payable returns (uint newMcdCdp)
    {
        TubInterface tub = TubInterface(getSaiTubAddress());
        bytes32 scdCup = bytes32(scdCDP);
        uint maxConvert = toConvert;

        if (toConvert < 10**18) {
            uint initialPoolBal = sub(getPoolAddress().balance, 10000000000);
            bytes32 splitCup = TubInterface(getSaiTubAddress()).open();

            // Check Thrilok - check if ratio is good.
            uint saiBal = tub.sai().balanceOf(daiJoin);
            uint _wadTotal = tub.tab(scdCup);
            uint _wad = wmul(_wadTotal, toConvert);

            // Check if sai_join has enough sai to migrate.
            if (saiBal < _wad) {
                _wad = sub(saiBal, 1000);
                // Set new convert ratio according to sai_join balance.
                maxConvert = sub(wdiv(saiBal, _wadTotal), 10);
            }

            uint _ink = wmul(tub.ink(scdCup), maxConvert); // Taking collateral in PETH only

            // getting liquidity from InstaDApp Pool.
            getLiquidity(_wad);

            wipe(scdCup, _wad, payFeeWith);
            free(scdCup, _ink);

            lock(splitCup, _ink);
            draw(splitCup, _wad);

            //transfer and payback liquidity to InstaDApp Pool.
            paybackLiquidity(_wad);

            uint finalPoolBal = getPoolAddress().balance;
            assert(finalPoolBal >= initialPoolBal);

            newMcdCdp = migrateToMCD(scdMcdMigration, splitCup, payFeeWith);
        } else {
            newMcdCdp = migrateToMCD(scdMcdMigration, scdCup, payFeeWith);
        }

        TokenInterface weth = TokenInterface(getWETHAddress());
        weth.withdraw(weth.balanceOf(address(this))); //withdraw WETH, if any leftover.
        msg.sender.transfer(address(this).balance); //transfer leftover ETH.

        // merge - Check Thrilok
        if (mergeCDP != 0) {
            require(ManagerLike(manager).owns(mergeCDP) == address(this), "NOT-OWNER");
            shiftCDP(manager, newMcdCdp, mergeCDP);

            emit LogMigrateAndMerge(
                uint(scdCup),
                maxConvert,
                payFeeWith,
                mergeCDP
            );
        } else {
            emit LogMigrate(
                uint(scdCup),
                maxConvert,
                payFeeWith,
                newMcdCdp
            );
        }
    }
}


contract InstaMcdMigrate is MigrateResolver {
    function() external payable {}
}