.PHONY: test

gen:
	gap_to_julia CAP

test:
	julia -e 'using Pkg; Pkg.test("CAP");'
