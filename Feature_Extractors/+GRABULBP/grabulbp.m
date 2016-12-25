% Local Binary Patterns (3 * 3 window) (Local Function implementation)
function feature_vector = lbp(input)
import Extractors.LBP.*;
feature_vector = LBP_Generic(input,10,50);
end

