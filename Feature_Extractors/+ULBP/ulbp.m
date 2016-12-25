% Local Binary Patterns (3 * 3 window) (Local Function implementation)
function feature_vector = ulbp(input)
import Extractors.ULBP.*;
feature_vector = ULBP_Generic(input,10,50);
end


