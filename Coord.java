/* -*- mode: java; c-basic-offset: 2; indent-tabs-mode: nil -*- */

/*

  3-vector of integers
 
  Derived from the Processing project PVector class - http://processing.org

  Copyright (c) 2008 Dan Shiffman
  Copyright (c) 2008-10 Ben Fry and Casey Reas
  
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License version 2.1 as published by the Free Software Foundation.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General
  Public License along with this library; if not, write to the
  Free Software Foundation, Inc., 59 Temple Place, Suite 330,
  Boston, MA  02111-1307  USA
*/


import java.io.Serializable;

/**
 * A class to describe a two or three dimensional vector.
 * <p>
 * The result of all functions are applied to the vector itself, with the
 * exception of cross(), which returns a new Coord (or writes to a specified
 * 'target' Coord). That is, add() will add the contents of one vector to
 * this one. Using add() with additional parameters allows you to put the
 * result into a new Coord. Functions that act on multiple vectors also
 * include static versions. Because creating new objects can be computationally
 * expensive, most functions include an optional 'target' Coord, so that a
 * new Coord object is not created with each operation.
 * <p>
 * Initially based on the Vector3D class by <a href="http://www.shiffman.net">Dan Shiffman</a>.
 */
public class Coord implements Serializable {


  /** The x component of the vector. */
  public int x;

  /** The y component of the vector. */
  public int y;

  /** The z component of the vector. */
  public int z;

  /** Array so that this can be temporarily used in an array context */
  transient protected int[] array;

  /**
   * Constructor for an empty vector: x, y, and z are set to 0.
   */
  public Coord() {
  }


  /**
   * Constructor for a 3D vector.
   *
   * @param  x the x coordinate.
   * @param  y the y coordinate.
   * @param  z the y coordinate.
   */
  public Coord(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }


  /**
   * Constructor for a 2D vector: z coordinate is set to 0.
   *
   * @param  x the x coordinate.
   * @param  y the y coordinate.
   */
  public Coord(int x, int y) {
    this.x = x;
    this.y = y;
    this.z = 0;
  }


  /**
   * Set x, y, and z coordinates.
   *
   * @param x the x coordinate.
   * @param y the y coordinate.
   * @param z the z coordinate.
   */
  public void set(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }


  /**
   * Set x, y, and z coordinates from a Vector3D object.
   *
   * @param v the Coord object to be copied
   */
  public void set(Coord v) {
    x = v.x;
    y = v.y;
    z = v.z;
  }


  /**
   * Set the x, y (and maybe z) coordinates using a int[] array as the source.
   * @param source array to copy from
   */
  public void set(int[] source) {
    if (source.length >= 2) {
      x = source[0];
      y = source[1];
    }
    if (source.length >= 3) {
      z = source[2];
    }
  }


  /**
   * Get a copy of this vector.
   */
  public Coord get() {
    return new Coord(x, y, z);
  }


  public int[] get(int[] target) {
    if (target == null) {
      return new int[] { x, y, z };
    }
    if (target.length >= 2) {
      target[0] = x;
      target[1] = y;
    }
    if (target.length >= 3) {
      target[2] = z;
    }
    return target;
  }



  /**
   * Add a vector to this vector
   * @param v the vector to be added
   */
  public void add(Coord v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }


  public void add(int x, int y, int z) {
    this.x += x;
    this.y += y;
    this.z += z;
  }


  /**
   * Add two vectors
   * @param v1 a vector
   * @param v2 another vector
   * @return a new vector that is the sum of v1 and v2
   */
  static public Coord add(Coord v1, Coord v2) {
    return add(v1, v2, null);
  }


  /**
   * Add two vectors into a target vector
   * @param v1 a vector
   * @param v2 another vector
   * @param target the target vector (if null, a new vector will be created)
   * @return a new vector that is the sum of v1 and v2
   */
  static public Coord add(Coord v1, Coord v2, Coord target) {
    if (target == null) {
      target = new Coord(v1.x + v2.x,v1.y + v2.y, v1.z + v2.z);
    } else {
      target.set(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
    }
    return target;
  }


  /**
   * Subtract a vector from this vector
   * @param v the vector to be subtracted
   */
  public void sub(Coord v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
  }


  public void sub(int x, int y, int z) {
    this.x -= x;
    this.y -= y;
    this.z -= z;
  }


  /**
   * Subtract one vector from another
   * @param v1 a vector
   * @param v2 another vector
   * @return a new vector that is v1 - v2
   */
  static public Coord sub(Coord v1, Coord v2) {
    return sub(v1, v2, null);
  }


  static public Coord sub(Coord v1, Coord v2, Coord target) {
    if (target == null) {
      target = new Coord(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
    } else {
      target.set(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
    }
    return target;
  }


  /**
   * Multiply this vector by a scalar
   * @param n the value to multiply by
   */
  public void mult(int n) {
    x *= n;
    y *= n;
    z *= n;
  }


  /**
   * Multiply a vector by a scalar
   * @param v a vector
   * @param n scalar
   * @return a new vector that is v1 * n
   */
  static public Coord mult(Coord v, int n) {
    return mult(v, n, null);
  }


  /**
   * Multiply a vector by a scalar, and write the result into a target Coord.
   * @param v a vector
   * @param n scalar
   * @param target Coord to store the result
   * @return the target vector, now set to v1 * n
   */
  static public Coord mult(Coord v, int n, Coord target) {
    if (target == null) {
      target = new Coord(v.x*n, v.y*n, v.z*n);
    } else {
      target.set(v.x*n, v.y*n, v.z*n);
    }
    return target;
  }


  /**
   * Multiply each element of one vector by the elements of another vector.
   * @param v the vector to multiply by
   */
  public void mult(Coord v) {
    x *= v.x;
    y *= v.y;
    z *= v.z;
  }


  /**
   * Multiply each element of one vector by the individual elements of another
   * vector, and return the result as a new Coord.
   */
  static public Coord mult(Coord v1, Coord v2) {
    return mult(v1, v2, null);
  }


  /**
   * Multiply each element of one vector by the individual elements of another
   * vector, and write the result into a target vector.
   * @param v1 the first vector
   * @param v2 the second vector
   * @param target Coord to store the result
   */
  static public Coord mult(Coord v1, Coord v2, Coord target) {
    if (target == null) {
      target = new Coord(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z);
    } else {
      target.set(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z);
    }
    return target;
  }


  /**
   * Divide this vector by a scalar
   * @param n the value to divide by
   */
  public void div(int n) {
    x /= n;
    y /= n;
    z /= n;
  }


  /**
   * Divide a vector by a scalar and return the result in a new vector.
   * @param v a vector
   * @param n scalar
   * @return a new vector that is v1 / n
   */
  static public Coord div(Coord v, int n) {
    return div(v, n, null);
  }


  static public Coord div(Coord v, int n, Coord target) {
    if (target == null) {
      target = new Coord(v.x/n, v.y/n, v.z/n);
    } else {
      target.set(v.x/n, v.y/n, v.z/n);
    }
    return target;
  }


  /**
   * Divide each element of one vector by the elements of another vector.
   */
  public void div(Coord v) {
    x /= v.x;
    y /= v.y;
    z /= v.z;
  }


  /**
   * Multiply each element of one vector by the individual elements of another
   * vector, and return the result as a new Coord.
   */
  static public Coord div(Coord v1, Coord v2) {
    return div(v1, v2, null);
  }


  /**
   * Divide each element of one vector by the individual elements of another
   * vector, and write the result into a target vector.
   * @param v1 the first vector
   * @param v2 the second vector
   * @param target Coord to store the result
   */
  static public Coord div(Coord v1, Coord v2, Coord target) {
    if (target == null) {
      target = new Coord(v1.x/v2.x, v1.y/v2.y, v1.z/v2.z);
    } else {
      target.set(v1.x/v2.x, v1.y/v2.y, v1.z/v2.z);
    }
    return target;
  }



  public String toString() {
    return "[ " + x + ", " + y + ", " + z + " ]";
  }


  /**
   * Return a representation of this vector as a int array. This is only for
   * temporary use. If used in any other fashion, the contents should be copied
   * by using the get() command to copy into your own array.
   */
  public int[] array() {
    if (array == null) {
      array = new int[3];
    }
    array[0] = x;
    array[1] = y;
    array[2] = z;
    return array;
  }

  @Override
  public boolean equals(Object obj) {
    if (!(obj instanceof Coord))
      return false;
    final Coord p = (Coord) obj;
    return x == p.x && y == p.y && z == p.z;
  }

  @Override
  public int hashCode() {
    int result = 1;
    result = 31 * result + x;
    result = 31 * result + y*1259;
    result = 31 * result + z*2591;
    return result;
  }
}
