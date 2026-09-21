# Linear Map

Linear map is a special type of homomorphism between vector spaces, which preserves the operations of vector addition and scalar multiplication :
$$
T(\mathbf{u} + \mathbf{v}) = T(\mathbf{u}) + T(\mathbf{v}), \quad T(c\mathbf{v}) = c T(\mathbf{v})
$$
So we can also treat linear map as a kind of transformation (or action) which is performed on vectors in the domain, resulting in vectors in the codomain.

## Homomorphism

When talk about homomorphism, a few properties need to be considered, such as:

- Null space, which set of vectors in the domain are mapped to the zero by the homomorphism.

- Range, which set of vectors in the codomain can be obtained if we send all elements from the domain through the homomorphism.

- Injectivity, whether only the zero in the domain is mapped to the zero in the codomain.

- Surjectivity, whether every vector in the codomain can be obtained by sending all elements from the domain through the homomorphism.

They reflect the fundamental structure-preserving nature of homomorphisms in linear algebra.

<br />

## Vector Space of Linear Maps

Collection of linear maps of same type forms a vector space over the same field as the domain and codomain, since it satisfies the addition closure and scalar multiplication closure properties of vector space, which can be expressed as follows:
$$
(\alpha T + \beta S)(\mathbf{v}) = \alpha T(\mathbf{v}) + \beta S(\mathbf{v}).
$$

Why it matters? This allows us to aggregate multiple linear maps (in same vector space) through addition and scalar multiplication, enabling more complex transformations to be constructed from simpler ones. Image that there are thousands of linear maps available; we can combine them in various ways to achieve desired transformations efficiently. This is amazing, is it?

<br />

## Matrix Representation 

Why we need a representation for linear map? Function is an abstract concept, and it can be difficult to work with directly. By representing a linear map as a matrix, we can leverage the well-developed tools and techniques of matrix algebra to perform computations, analyze properties, and understand the behavior of the linear map more concretely.

As we know, linear map is a kind of transformation that performed on vectors in the domain. And a vector space is determined by its basis. So each linear map should be uniquely determined by its action and two vector spaces on both sides :

- The basis of the domain vector space.

- The basis of the codomain vector space.

- The linear map function itself.

Apply action (function) on each basis vector of the domain, resuting in a set of vectors in the codomain. These resulting vectors can then be expressed as linear combinations of the basis vectors of the codomain, forming the columns of the matrix representation of the linear map. So matrix of linear map reflects the coordinates of each basis vectors of the domain in terms of the basis vectors of the codomain.

<br />

### Bijectivity

Bijectivity is a more strong property than injectivity or surjectivity alone. A linear map is bijective if it is both injective (one-to-one) and surjective (onto), meaning that every vector in the codomain is the image of exactly one vector in the domain. This implies two vector spaces have the exact same structure, it hides the underlying data representation, and allows for the existence of an inverse linear map that can uniquely recover the original vectors from the codomain.