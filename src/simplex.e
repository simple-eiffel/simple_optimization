note
	description: "Nelder-Mead simplex vertex management"
	author: "Larry Rix"

class
	SIMPLEX

create
	make

feature {NONE} -- Initialization

	make (a_vertices: ARRAY [ARRAY [REAL_64]]; a_values: ARRAY [REAL_64])
			-- Create simplex with n+1 vertices and function values.
		require
			vertices_not_void: a_vertices /= Void
			vertices_not_empty: a_vertices.count > 0
			values_not_void: a_values /= Void
			compatible_count: a_values.count = a_vertices.count
		do
			vertices := a_vertices
			values := a_values
		ensure
			vertices_set: vertices = a_vertices
			values_set: values = a_values
		end

feature -- Access

	vertices: ARRAY [ARRAY [REAL_64]]
			-- n+1 vertices

	values: ARRAY [REAL_64]
			-- Function values at vertices

	dimension: INTEGER
			-- Problem dimension (n)
		do
			Result := vertices [vertices.lower].count - 1
		end

	worst_index: INTEGER
			-- Index of worst (highest) function value
		local
			i: INTEGER
		do
			Result := values.lower
			from i := values.lower + 1 until i > values.upper loop
				if values [i] > values [Result] then
					Result := i
				end
				i := i + 1
			end
		end

	best_index: INTEGER
			-- Index of best (lowest) function value
		local
			i: INTEGER
		do
			Result := values.lower
			from i := values.lower + 1 until i > values.upper loop
				if values [i] < values [Result] then
					Result := i
				end
				i := i + 1
			end
		end

	centroid (excluding: INTEGER): ARRAY [REAL_64]
			-- Centroid excluding vertex at excluding index.
		local
			i, j: INTEGER
			l_dim: INTEGER
			l_count: INTEGER
			l_result: ARRAY [REAL_64]
		do
			l_dim := dimension + 1
			create l_result.make_filled (0.0, 1, l_dim)
			l_count := 0
			from i := vertices.lower until i > vertices.upper loop
				if i /= excluding then
					from j := 1 until j > l_dim loop
						l_result [j] := l_result [j] + vertices [i][j]
						j := j + 1
					end
					l_count := l_count + 1
				end
				i := i + 1
			end
			from j := 1 until j > l_dim loop
				if l_count > 0 then
					l_result [j] := l_result [j] / l_count
				end
				j := j + 1
			end
			Result := l_result
		end

	diameter: REAL_64
			-- Max distance between vertices (simplex size).
		local
			i, j: INTEGER
			max_dist, dist, sum: REAL_64
		do
			max_dist := 0.0
			from i := vertices.lower until i > vertices.upper - 1 loop
				from j := i + 1 until j > vertices.upper loop
					sum := 0.0
					from j := 1 until j > vertices [i].count loop
						sum := sum + (vertices [i][j] - vertices [j][j]) * (vertices [i][j] - vertices [j][j])
						j := j + 1
					end
					dist := sum.sqrt
					if dist > max_dist then
						max_dist := dist
					end
					j := j + 1
				end
				i := i + 1
			end
			Result := max_dist
		end

invariant
	vertices_not_void: vertices /= Void
	values_not_void: values /= Void
	compatible_count: values.count = vertices.count

end
