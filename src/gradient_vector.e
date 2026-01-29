note
	description: "Immutable gradient vector for optimization"
	author: "Larry Rix"

class
	GRADIENT_VECTOR

create
	make

feature {NONE} -- Initialization

	make (a_components: ARRAY [REAL_64])
			-- Create gradient from component array.
		require
			components_not_void: a_components /= Void
			components_not_empty: a_components.count > 0
		do
			components := a_components
		ensure
			components_set: components = a_components
		end

feature -- Access

	components: ARRAY [REAL_64]
			-- Gradient components

	dimension: INTEGER
			-- Number of components
		do
			Result := components.count
		end

	magnitude: REAL_64
			-- ||∇f|| for convergence check
		local
			i: INTEGER
			sum: REAL_64
		do
			sum := 0.0
			from i := components.lower until i > components.upper loop
				sum := sum + components [i] * components [i]
				i := i + 1
			end
			Result := sum.sqrt
		ensure
			non_negative: Result >= 0.0
		end

feature -- Operations

	dot_product (other: GRADIENT_VECTOR): REAL_64
			-- Dot product with another gradient.
		require
			other_not_void: other /= Void
			compatible_dimension: other.dimension = dimension
		local
			i: INTEGER
			sum: REAL_64
		do
			sum := 0.0
			from i := components.lower until i > components.upper loop
				sum := sum + components [i] * other.components [i]
				i := i + 1
			end
			Result := sum
		end

	scale (scalar: REAL_64): GRADIENT_VECTOR
			-- Scalar multiplication.
		local
			i: INTEGER
			l_scaled: ARRAY [REAL_64]
		do
			create l_scaled.make_filled (0.0, components.lower, components.upper)
			from i := components.lower until i > components.upper loop
				l_scaled [i] := scalar * components [i]
				i := i + 1
			end
			create Result.make (l_scaled)
		ensure
			result_not_void: Result /= Void
			result_dimension: Result.dimension = dimension
		end

invariant
	components_not_void: components /= Void
	immutable: True

end
