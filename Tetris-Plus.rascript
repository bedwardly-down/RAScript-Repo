// Tetris Plus
// #ID = 3145

// States
function glb_Stt() => dword(0x3e6b0)
function lcl_Stt() => dword(0x89b70)

stt = {
	0: "Company Logo",
	1: "Copyright",
	2: "Intro Cutscene",
	3: "Title Screen",
	4: "Demo 1",
	5: "Demo 2",
	6: "Demo 3",
	7: "Rankings",
	8: "Mode Screens",
	9: "Classic Mode",
	0x0a: "Puzzle Mode",
	0x0b: "Vs Mode",
	0x0c: "Edit Mode"
}

// Classic Mode Related
function lc_Cnt() => dword(0xc4d88)
function lc_Cls() => dword(0xc4e90)
function lc_ClsTrs() => dword(0xc4d90)
function lc_ClsTpl() => dword(0xc4d98)
function lc_ClsDbl() => dword(0xc4da0)
function lc_ClsSgl() => dword(0xc4da8)

// Puzzle Mode Related
function pzl_Map() => byte(0x3f570)
function pzl_Stg() => dword(0xeeb04)

map = {
	0x1d: "Egypt",
	0x1e: "Egypt",
	0x1f: "Egypt",
	0x20: "Angkor Wat",
	0x21: "Angkor Wat",
	0x22: "Angkor Wat",
	0x23: "Maya",
	0x24: "Maya",
	0x25: "Maya",
	0x26: "Knossos",
	0x27: "Knossos",
	0x28: "Knossos",
	0x29: "Atlantis",
	0x2a: "Atlantis",
	0x2b: "Atlantis",
	0x2c: "Map"
}

// Password Related 
function pwd_Pos() => dword(0xf0bbc)
function pwd_Ipt() => dword(0xee4f4)

pwd = {}
init = 0x4ab90
offset = 0x7c
for i in range(0, 5) {
	pwd[i] = byte(init + (i * offset))
}

// Loot / Score Related
function pzl_Scr() => dword(0xee3b4)
function trs_Flg() => dword(0x4afe8)
function lc_Pzl(i) {
	rtn = always_true()
	x = always_true()
	if i == 0 {
		rtn = pzl_Scr() -
			prev(pzl_Scr()) >= lc_Sng
	}  

	if i > 0 {
		if i == 1 {
			x = lc_Sng
		} else if i == 2 {
			x = lc_Dbl
		} else if i == 3 {
			x = lc_Tpl
		} else if i == 4 {
			x = lc_Trs 
		}

		rtn = pzl_Scr() - 
			prev(pzl_Scr()) == x
	}

	return rtn
}

// Individual Score Types
dth = 1
lc_Sng = 100
lc_Dbl = 400
lc_Tpl = 800
lc_Trs = 1600

// Helper Functions
// Password / Save Protection
function stg_Sv() => dword(0xee38c)

function stg_Cht() =>
	 unless(
	 once(
	 pwd[0] == 0xc2 &&
	 pwd[1] == 0xc6 &&
	 pwd[2] == 0xc5 &&
	 pwd[3] == 0xc2 &&
	 pwd[4] == 0xc6 &&
	 pwd[5] == 0xc5)) &&
	 unless(
	 once(
	 stg_Sv() == 1))

function stg_Ld() =>
	unless(
	once(
	pwd_Ipt() > prev(pwd_Ipt())))

// Fail Protection
function stg_Fl(a) =>
	unless(
	tally(a,
	unless(
	prev(lcl_Stt()) == 5 &&
	lcl_Stt() == 6)))

// Achievements
achievement(
	title = "Any Line Will Do",
	description = "Clear your first line in Classic Mode.",
	points = 1,
	trigger =
		glb_Stt() == 0x09 &&
		lcl_Stt() == 0x02 &&
		lc_Cnt() > prev(lc_Cnt()),
	badge = "128843",
	id = 117862
)

achievement(
	title = "Any Line Will Do 2",
	description = "Clear your first line in Puzzle Mode",
	points = 1,
	trigger = 
		glb_Stt() == 0x0a &&
		lcl_Stt() == 0x05 &&
		lc_Pzl(0),
	id = 119149,
	badge = "130140"
)

achievement(
	title = "Any Treasure Will Do",
	description = "Collect your first treasure in Puzzle Mode",
	points = 1,
	trigger = (
		glb_Stt() == 0x0a &&
		lcl_Stt() == 0x09 &&
		trs_Flg() > prev(trs_Flg()) &&
		stg_Cht()) ||
	   (always_false() &&
	    never(glb_Stt() != prev(glb_Stt()))),
	badge = "131404",
	id = 120394
)

achievement(
	title = "Begone Foul Trap",
	description = "Obtain your first Triple Special Recovery in Puzzle Mode",
	points = 2,
	trigger = 
		glb_Stt() == 0x0a &&
		lcl_Stt() == 0x05 &&
		lc_Pzl(3),
	badge = "172266",
	id = 119147
)

achievement(
	title = "Entrapment",
	description = "Obtain your first Tetris Special Recovery in Puzzle Mode",
	points = 3,
	trigger =
		glb_Stt() == 0x0a &&
		lcl_Stt() == 0x05 &&
		lc_Pzl(4),
	badge = "172267",
	id = 119148
)

function lc_PzlTp(c) =>
	measured(
	tally(c,
	lc_Pzl(3),
	lc_Pzl(4),
	always_false()
	))

achievement(
	title = "Trap Star",
	description = "Perform 10 total Special Recoveries in Puzzle Mode in one session (No stage skip, No passwords)",
	points = 25,
	trigger = 
		glb_Stt() == 0x0a &&
		lcl_Stt() == 0x05 &&
		stg_Ld() &&
		unless(
		lcl_Stt() == 0x09 ||
		lcl_Stt() == 0x06) &&
		lc_PzlTp(10) ||
		(always_false() &&
		never(glb_Stt() != prev(glb_Stt()))),
	badge = "172268",
	id = 153478
)

achievement(
	title = "Tetris Builder",
	description = "Load up Edit Mode",
	points = 1,
	trigger =
		glb_Stt() == 0x0c &&
		dword(0x3e6c0) == 8,
	id = 120396,
	badge = "131408"
)

achievement(
	title = "Any Stage Will Do",
	description = "Complete your first stage in Puzzle Mode",
	points = 1,
	trigger =
		glb_Stt() == 0x0a &&
		prev(lcl_Stt()) == 5 &&
		lcl_Stt() == 9,
	id = 117863,
	badge = "128845"
)

achievement(
	title = "It's Dangerous to Go Alone",
	description = "Clear 25 single lines in Classic Mode in one run",
	points = 5,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(25,
		lc_ClsSgl() > prev(lc_ClsSgl()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "128836",
	id = 117448
)

achievement(
	title = "Still Single?",
	description = "Clear 50 single lines in Classic Mode in one run",
	points = 10,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(50,
		lc_ClsSgl() > prev(lc_ClsSgl()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "130217",
	id = 119293
)

achievement(
	title = "The One to Rule Them All",
	description = "Clear 100 single lines in Classic Mode in one run",
	points = 25,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(100,
		lc_ClsSgl() > prev(lc_ClsSgl()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "130220",
	id = 119294
)

achievement(
	title = "Double Trouble",
	description = "Clear 25 double lines in Classic Mode in one run",
	points = 10,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(25,
		lc_ClsDbl() > prev(lc_ClsDbl()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "128837",
	id = 117544
)

achievement(
	title = "Take Two",
	description = "Clear 50 double lines in Classic Mode in one run",
	points = 25,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(50,
		lc_ClsDbl() > prev(lc_ClsDbl()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "130224",
	id = 119298
)

achievement(
	title = "This Is Triple-E",
	description = "Clear 10 triple lines in Classic Mode in one run",
	points = 25,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(10,
		lc_ClsTpl() > prev(lc_ClsTpl()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "128840",
	id = 119295
)

achievement(
	title = "Triple Threat",
	description = "Clear 25 triple lines in Classic Mode in one run",
	points = 50,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(25,
		lc_ClsTpl() > prev(lc_ClsTpl()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "130228",
	id = 119301
)

achievement(
	title = "Double Date",
	description = "Clear 10 tetris lines in Classic Mode in one run",
	points = 25,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(10,
		lc_ClsTrs() > prev(lc_ClsTrs()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "128841",
	id = 119304
)

achievement(
	title = "Four Times the Fun",
	description = "Clear 25 tetris lines in Classic Mode in one run",
	points = 50,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		measured(
		tally(25,
		lc_ClsTrs() > prev(lc_ClsTrs()))) &&
		never(glb_Stt() != prev(glb_Stt())) &&
		never(lcl_Stt() == 3),
	badge = "130232",
	id = 117545
)

function lc_Pzlnr(a) =>
	measured(
	tally(a,
	lc_Pzl(1),
	lc_Pzl(2),
	lc_Pzl(3),
	lc_Pzl(4),
	always_false()))

achievement(
	title = "Puzzliner",
	description = "Clear 250 total lines in Puzzle Mode in one session (No stage skip, No passwords, 5 fail limit)",
	points = 50,
	trigger =
	   (glb_Stt() == 0x0a &&
		lcl_Stt() == 5 &&
		unless(lcl_Stt() == 9) &&
		stg_Ld() &&
		stg_Fl(5) &&
		lc_Pzlnr(250)) ||
		never(glb_Stt() != prev(glb_Stt())) &&
		always_false(),
	badge = "172495",
	id = 153742
)

achievement(
	title = "Easy as 1, 2, 3... and 4?",
	description = "Perform exactly 1 tetris, 2 triple, 3 double and 4 single line clears in any order in Classic Mode in one run",
	points = 5,
	trigger =
		glb_Stt() == 9 &&
		lcl_Stt() == 2 &&
		lc_Cnt() == 20 &&
		lc_ClsTrs() == 1 &&
		lc_ClsTpl() == 2 &&
		lc_ClsDbl() == 3 &&
		lc_ClsSgl() == 4,
	badge = "128846",
	id = 117864
)

// Puzzle Mode Progression
prg_Ttl = {
	0: "Egyptologist",
	1: "Mayanist",
	2: "Knossosist",
	3: "Angkorologist",
	4: "Atlantian"
}

prg_Dsc = {
	0: "Egypt",
	1: "Mayan",
	2: "Knossos",
	3: "Angkor Wat",
	4: "Atlantis"
}

prg_Pt = {
	0: 10,
	1: 10,
	2: 10,
	3: 10,
	4: 25
}

prg_MPt = {
	0: 25,
	1: 25,
	2: 25,
	3: 25,
	4: 50
}

prg_Trg = {
	0: (pzl_Map() >= 0x1d &&
		pzl_Map() <= 0x1f),
	1: (pzl_Map() >= 0x23 &&
		pzl_Map() <= 0x25),
	2: (pzl_Map() >= 0x26 &&
		pzl_Map() <= 0x28),
	3: (pzl_Map() >= 0x20 &&
		pzl_Map() <= 0x22),
	4: (pzl_Map() >= 0x29 &&
		pzl_Map() <= 0x2b)
}

prg_Bdg = {
	0: "131303",
	1: "131304",
	2: "131305",
	3: "131301",
	4: "131402"
}

prg_MBdg = {
	0: "131341",
	1: "131340",
	2: "131335",
	3: "131338",
	4: "131400"
}

prg_ID = {
	0: 120323,
	1: 120325,
	2: 120330,
	3: 120328,
	4: 120393
}

prg_MID = {
	0: 120324,
	1: 120326,
	2: 120329,
	3: 120327,
	4: 120392
}

for i in prg_Ttl {
	achievement(
		title = format("{0}", prg_Ttl[i]),
		description = format("Complete all 20 stages of {0} in one session \(No stage skip, No password\)", prg_Dsc[i]),
		points = prg_Pt[i],
		trigger = (
			glb_Stt() == 0x0a &&
			lcl_Stt() == 5 &&
			stg_Ld() &&
			prg_Trg[i] &&
			tally(20,
			prev(lcl_Stt()) == 5 &&
			lcl_Stt() == 9)) ||
		   (never(glb_Stt() != prev(glb_Stt())) &&
			always_false()),
		id = prg_ID[i],
		badge = prg_Bdg[i]
	)

	achievement(
		title = format("Master {0}", prg_Ttl[i]),
		description = format("Complete all 20 stages of {0} in one session \(No stage skip, No password, 5 fail limit\)", prg_Dsc[i]),
		points = prg_MPt[i],
		trigger = (
			glb_Stt() == 0x0a &&
			lcl_Stt() == 5 &&
			stg_Ld() &&
			stg_Fl(5) &&
			prg_Trg[i] &&
			tally(20,
			prev(lcl_Stt()) == 5 &&
			lcl_Stt() == 9)) ||
		   (never(glb_Stt() != prev(glb_Stt())) &&
			always_false()),
		id = prg_MID[i],
		badge = prg_MBdg[i]
	)
}

// Liner Achievements
lnr_Ttl = {
	0: "Front",
	1: "Back",
	2: "Head"
}

lnr_Dsc = {
	0: 100,
	1: 250,
	2: 500
}

lnr_Pt = {
	0: 10,
	1: 25,
	2: 50
}

lnr_Bdg = {
	0: "129196",
	1: "129197",
	2: "129198"
}

lnr_ID = {
	0: 117865,
	1: 117866,
	2: 117867
}

for i in lnr_Ttl {
	achievement(
		title = format("{0}liner", lnr_Ttl[i]),
		description = format("Clear {0} lines in Classic Mode in one session", lnr_Dsc[i]),
		points = lnr_Pt[i],
		trigger =
			glb_Stt() == 9 &&
			lcl_Stt() == 2 &&
			lc_Cnt() >= lnr_Dsc[i],
		badge = lnr_Bdg[i],
		id = lnr_ID[i]
	)
}
