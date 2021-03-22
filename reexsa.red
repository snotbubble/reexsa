Red [ needs 'view ]

marg: 10
tabh: 0 ;; height of the statusbar (none atm)

nudgeu: func [] [
	uu/offset/x: 0
	uu/offset/y: min (max 200 uu/offset/y) 600
	uu/size/x: tp/size/x
	vv/offset/y: uu/offset/y + 10
	vv/size/y: tp/size/y - ((uu/offset/y + 10) + tabh)
	maa/offset/y: 0
	maa/size/x: uu/size/x
	mbb/offset/y: uu/offset/y + 10
	mcc/offset/y: uu/offset/y + 10
	maa/size/y: uu/offset/y
	mbb/size/y: vv/size/y
	mcc/size/y: vv/size/y
	maah/offset/y: 0
	mbbh/offset/y: 0
	mcch/offset/y: 0
	maap/offset/y: maah/size/y + marg
	mbbp/offset/y: mbbh/size/y + marg
	mccp/offset/y: mcch/size/y + marg
	maap/size/y: maa/size/y - (maah/size/y + (2 * marg))
	mbbp/size/y: mbb/size/y - (mbbh/size/y + (2 * marg))
	mccp/size/y: mcc/size/y - (mcch/size/y + (2 * marg))
	uu/draw: compose/deep [ 
		pen off 
		fill-pen 100.100.100
		circle (to-pair compose/deep [(to-integer (uu/size/x * 0.5) - 10) 5]) 2 2 
		circle (to-pair compose/deep [(to-integer (uu/size/x * 0.5)) 5]) 2 2
		circle (to-pair compose/deep [(to-integer (uu/size/x * 0.5) + 10) 5]) 2 2 
	]
]

nudgev: func [] [
	vv/offset/y: uu/offset/y + 10
	vv/offset/x: min (max 100 vv/offset/x) (tp/size/x - 100)
	if vv/offset/x < 100 [ return 0 ]
	maa/offset/x: 0
	mbb/offset/x: 0
	mcc/offset/x: vv/offset/x + 10 
	mbb/size/x: vv/offset/x
	mcc/size/x: (tp/size/x - mcc/offset/x)
	maah/offset/x: 0
	mbbh/offset/x: 0
	mcch/offset/x: 0
	maah/size/x: maa/size/x
	mbbh/size/x: mbb/size/x
	mcch/size/x: mcc/size/x
	maap/offset/x: marg
	mbbp/offset/x: marg
	mccp/offset/x: marg
	maap/size/x: maah/size/x - (marg + marg + 1)
	mbbp/size/x: mbbh/size/x - (marg + marg)
	mccp/size/x: mcch/size/x - (marg + marg + 1)
	vv/draw: compose/deep [ 
		pen off 
		fill-pen 100.100.100
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5) - 10)]) 2 2 
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5))]) 2 2
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5) + 10)]) 2 2 
	]
]

view/tight/flags/options [
	below
	hh: panel 800x55 35.35.35 [
		parsers: drop-list 200x30 font-name "consolas" font-size 10 font-color 180.180.180 bold data (collect [foreach file read %./ [ if (find (to-string file) ".parse") [keep rejoin ["./" (to-string file)]] ]]) on-change [
		    pfn: copy parsers/data/(parsers/selected)
			pn: ""
			parse pfn [ thru "./" copy pn to ".parse" ]
			parsername/text: pn
			pset: load to-file parsers/data/(parsers/selected)
			maap/text: (reduce pset/1)
			mbbp/text: (reduce pset/2)
		]
		pad 10x0
		parsername: field 200x30 font-name "consolas" font-size 10 font-color 180.180.180 bold
		pnew: button 80x30 "save" font-name "consolas" font-size 10 font-color 180.180.180 bold [ 
			if (parsername/text <> "") and (parsername/text <> none) [
			   	newparsername: rejoin [ "./" parsername/text ".parse" ]
			    write to-file newparsername ( reduce [ maap/text mbbp/text ])
				clear parsers/data
				parsers/data: (collect [foreach file read %./ [ if (find (to-string file) ".parse") [keep rejoin ["./" (to-string file)]] ]])
				parsers/selected: index? find parsers/data newparsername
			]
		]
		pad 10x0
		psave: button 160x30 "save output" font-name "consolas" font-size 10 font-color 180.180.180 bold [ op: request-dir unless none? op [ probe op write to-file rejoin [ op "parsed_text.txt" ] mccp/text ] ]
	]
	tp: panel 800x745 [
		below
		maa: panel 800x300 40.40.40 [
			maah: panel 45.45.45 800x55 [
				text 200x30 "parse" font-name "consolas" font-size 24 font-color 80.80.80 bold
			]
			maap: area 800x300 40.40.40 font-name "consolas" font-size 12 font-color 128.255.128 bold with [
				text: {parse s [ any [ to "^^/* " change "^^/* " "^^/<li>" pre: [ to "^^/" change "^^/" "</li>^^/" | to end change end "</li>" end ] :pre ] ]^/parse s [ any [ to "^^/<li>" not "</li>^^/<li>" change "^^/<li>" "<ul>^^/<li>" ] ]}
			] on-change [ face/font/color: 255.0.0 s: copy mbbp/text do maap/text mccp/text: s face/font/color: 128.255.128 ] 
		]
		uu: panel 800x10 30.30.30 loose [] on-drag [ nudgeu ]
		across
		mbb: panel 390x400 40.40.40 [
			mbbh: panel 390x55 45.45.45 [
				text 200x30 "source" font-name "consolas" font-size 24 font-color 80.80.80 bold
			]
			mbbp: area 390x300 40.40.40 font-name "consolas" font-size 12 font-color 128.255.255 bold with [
				text: {a list:^/* one^/* two^/* three^/end of * list^/another list^/* AAA^/* BBB^/end of the other list} ;;*/ <- emacs red-mode is screwy atm
			] on-change [ face/font/color: 255.0.0 s: copy mbbp/text do maap/text mccp/text: s face/font/color: 128.255.128 ] 
		]
		vv: panel 10x390 30.30.30 loose [] on-drag [ nudgev ]
		mcc: panel 390x400 40.40.40 [
			mcch: panel 390x55 45.45.45 [
				text 200x30 "result" font-name "consolas" font-size 24 font-color 80.80.80 bold
			]
			mccp: area 390x345 40.40.40 font-name "consolas" font-size 12 font-color 255.255.128 bold
		]   	
	]
	do [ 
		if exists? %./default.parse [ 
			pset: load %./default.parse
			maap/text: (reduce pset/1)
			mbbp/text: (reduce pset/2)
			parsername/text: "default"
			parsers/selected: index? find parsers/data "./default.parse"
		]
		pnew/offset/x: tp/size/x - (pnew/size/x + marg)
		psave/offset/x: pnew/offset/x - (psave/size/x + marg)
		parsername/offset/x: (parsers/offset/x + parsers/size/x + marg)
		parsername/size/x: psave/offset/x - (parsers/size/x + (4 * marg)) 
		nudgeu nudgev 
	]
] [ resize ] [
	actors: object [
		on-resizing: function [ face event ] [
			if face/size/x > 500 [
				if face/size/y > (uu/offset/y + 200) [
					hh/size/x: face/size/x
					tp/size: face/size - 0x55
					pnew/offset/x: face/size/x - (pnew/size/x + marg)
					psave/offset/x: pnew/offset/x - (psave/size/x + marg)
					parsername/offset/x: (parsers/offset/x + parsers/size/x + marg)
					parsername/size/x: psave/offset/x - (parsers/size/x + (4 * marg))
					nudgeu nudgev
				]
			]
		]
	]
]
