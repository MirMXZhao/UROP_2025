// MODULE main
// 	int x;
// 	int y;
// 	int w;
// 	int z;

// 	int turn;

// 	assume(x == 0);
// 	assume(y == 0);
// 	assume(z == 0);
// 	assume(w == 1);
// 	assume(turn == 0);

// 	while(*){}

// 	assert(x == y);	

// END MODULE


// (let ((.def_28 (= x y))) (let ((.def_1294 (<= (+ x (* (- 1) y)) (- 1)))) (let ((.def_1298 (<= 1 (+ x (* (- 1) y))))) (let ((.def_3281 (and (not (<= 0 (+ z (* 2 (to_int (* (/ 1 2) (to_real (* (- 1) z)))))))) (not (<= 1 (+ w (* 2 (to_int (* (/ 1 2) (to_real (+ (* (- 1) w) 1))))))))))) (not (and (and (not (and (not .def_1298) (and (not .def_1294) .def_3281))) (not (and .def_28 .def_3281))) (not (and (not (<= (to_real (+ w (* (- 2) (to_int (* (/ 1 2) (to_real (* 1 w))))))) (to_real 0))) (and (not (and (not .def_28) (or .def_1294 .def_1298))) (not (<= (to_real 1) (to_real (+ z (* 2 (to_int (* (/ 1 2) (to_real (+ (* (- 1) z) 1))))))))))))))))))

method Main() returns (x: int, y: int)
	ensures x == y;
{}



