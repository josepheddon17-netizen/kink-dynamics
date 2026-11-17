# First Definitions

Take some scalar field, $\phi(x,t)$, and a non-negative potential energy density, $U(\phi)$. We desire to find a solution to our governing PDE:

$$
\frac{\partial^2 \phi}{\partial t^2}=\frac{\partial^2 \phi}{\partial x^2}-\frac{d U}{d \phi} .
$$

A _kink_ is a solution that satisfies 

$$
\lim _{x \rightarrow-\infty} \phi(x, t)=\phi_{-}, \quad \lim _{x \rightarrow+\infty} \phi(x, t)=\phi_{+},
$$

where $\phi_{-}<\phi_{+}$ and $U\left(\phi_{ \pm}\right)=0$. An anti-kink is a solution satisfying the same conditions but with $\phi_{-}>\phi_{+}$.  For the $\phi^4$ theory, we take $U(\phi) = \frac{1}{2} (1-\phi^2)^2$, and this gives us:

$$
\lim _{x \rightarrow-\infty} \phi(x,t)=-1
$$

and

$$
\lim _{x \rightarrow+\infty} \phi(x,t)=+1 .
$$

As we move between spatial infinities, there is a smooth localised transition between $-1\rightarrow1$ -  this is a kink.

# Derivation of a Static Solution

Our first goal is to derive an analytical solution to our model when the solution is static.
## Step 1 : Reduce the PDE to an ODE

A static solution takes:

$$
\frac{\partial \phi}{\partial t} = \frac{\partial^2 \phi}{\partial t^2} = 0.
$$

We can substitute this into our equation:

$$
0= \frac{\partial^2 \phi}{\partial x^2} +2 \phi (1-\phi^2),
$$

$$
\frac{\partial^2 \phi}{\partial x^2} = 2 \phi (\phi^2-1).
$$

Our PDE has now became an ODE:

$$
\frac{d^2 \phi}{dx^2} = 2 \phi (\phi^2-1).
$$

## Step 2 : Reduce the order of the equation

To reduce the order here, we will want to multiply both sides by $\frac{d \phi}{dx}$:

$$
\frac{d^2 \phi}{dx^2}\frac{d \phi}{dx}  = 2 \phi \frac{d \phi}{dx} (\phi^2-1).
$$

Both sides of the equation can be wrote as a derivative of some other function:

$$
\frac{d^2 \phi}{dx^2}\frac{d \phi}{dx} = \frac{d}{dx} (\frac{1}{2} (\frac{d\phi}{dx})^2),
$$ 

and

$$
2 \phi \frac{d \phi}{dx} (\phi^2-1) = \frac{d}{dx}(\frac{1}{2}(\phi^2 -1)^2).
$$

Using these identities, we can simplify our equation to:

$$
\frac{d}{dx} (\frac{1}{2} (\frac{d\phi}{dx})^2) = \frac{d}{dx}(\frac{1}{2}(\phi^2 -1)^2).
$$

Which can then be integrated with respect to $x$:

$$
\frac{1}{2} (\frac{d\phi}{dx})^2 =  \frac{1}{2}(\phi^2 -1)^2)+C,
$$

or

$$
(\frac{d\phi}{dx})^2 =  (\phi^2 -1)^2)+2C.
$$

## Step 3 : Using boundary conditions to find C

Since a kink connects $-1$ and $1$, we know:

$$
\phi(-\infty)=-1, \quad \phi(+\infty)=+1,
$$

and the field becomes approximately constant at the end points so:

$$
\phi^{\prime}(-\infty)=\phi^{\prime}(+\infty)=0 .
$$

This can be substituted into our equation:

$$
0=\left(1^2-1\right)^2+2 C .
$$

Hence,

$$
C=0 .
$$

Which means our equation has become:

$$
(\frac{d\phi}{dx})^2 =  (1-\phi^2)^2.
$$

The reordering of terms on the RHS is to ensure a non-negative number has been square rooted since $\phi \in [-1,1]$. Taking square roots,

$$
\frac{d\phi}{dx} =  \pm (1-\phi^2).
$$

When we take this equation as positive, we find the function for a kink, when it is negative we get an anti-kink. By solving the positive equation, we can negate it to find the negative equation solution.

## Step 4 : Separating Variables and solving

$$
\frac{d \phi}{d x}=1-\phi^2 .
$$

Separating variables,

$$
\frac{d \phi}{1-\phi^2}=d x .
$$

We can use partial fractions:

$$
\begin{gathered}
\frac{1}{1-\phi^2}=\frac{1}{(1-\phi)(1+\phi)} \\
=\frac{1}{2}\left(\frac{1}{1+\phi}+\frac{1}{1-\phi}\right) .
\end{gathered}
$$

Integrating both sides,

$$
\frac{1}{2} \int\left(\frac{1}{1+\phi}+\frac{1}{1-\phi}\right) d \phi=\int d x
$$

Therefore,

$$
\frac{1}{2} \ln \left|\frac{1+\phi}{1-\phi}\right|=x+C_1 .
$$

Multiplying by two and exponentiating,

$$
\frac{1+\phi}{1-\phi}=A e^{2 x},
$$

where $A=e^{2 C_1}>0$. Rearranging,

$$
\begin{gathered}
1+\phi=A e^{2 x}(1-\phi) \\
\phi\left(1+A e^{2 x}\right)=A e^{2 x}-1
\end{gathered}
$$

Thus,

$$
\phi=\frac{A e^{2 x}-1}{A e^{2 x}+1} .
$$

Dividing the numerator and denominator by $A e^{2 x}$,

$$
\phi=\frac{1-A^{-1} e^{-2 x}}{1+A^{-1} e^{-2 x}}
$$

Recall the identity

$$
\tanh (z)=\frac{1-e^{-2 z}}{1+e^{-2 z}}
$$

Setting

$$
A^{-1} e^{-2 x}=e^{-2\left(x-x_0\right)}
$$

gives

$$
A=e^{2 x_0} .
$$

Therefore,

$$
\phi_K(x)=\tanh \left(x-x_0\right) .
$$

This is the exact static kink solution. The anti-kink solution is therefore:
$$
\phi_{\overline{K}(x)}=\tanh \left(x-x_0\right) .
$$

# Interpreting our Analytical Solution 

So our analytical solution for a kink is:

$$
\phi_K(x)=\tanh \left(x-x_0\right)
$$

where $x_0$ determines the position of the kink. The kink is the transition from $-1$ on the left to $+1$ on the right. For example, if $x_0=0$,

$$
\phi_K(x)=\tanh (x) .
$$

This function has exactly the behaviour we want:

$$
\begin{aligned}
& \lim _{x \rightarrow-\infty} \tanh (x)=-1, \\
& \lim _{x \rightarrow+\infty} \tanh (x)=+1 .
\end{aligned}
$$

It is also a solution of the static field equation

$$
\frac{d^2 \phi}{d x^2}=\frac{d U}{d \phi} .
$$

An analytical solution allows us to test against with our finite difference scheme in MATLAB. All an anti-kink is the transition from $+1$ on the left to $-1$ on the right.
