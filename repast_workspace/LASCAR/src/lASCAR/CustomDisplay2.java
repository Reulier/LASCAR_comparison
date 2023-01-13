package lASCAR;

import java.awt.Color;
import java.awt.Font;

import repast.simphony.visualizationOGL2D.StyleOGL2D;
import saf.v3d.ShapeFactory2D;
import saf.v3d.scene.Position;
import saf.v3d.scene.VSpatial;

/**
 * Default 2D OGL Style.
 */

@SuppressWarnings({ "rawtypes" })
public class CustomDisplay2 implements StyleOGL2D {
  
  protected ShapeFactory2D shapeFactory;

  /* (non-Javadoc)
   * @see repast.simphony.visualizationOGL2D.StyleOGL2D#init(saf.v3d.ShapeFactory2D)
   */
  public void init(ShapeFactory2D factory) {
    this.shapeFactory = factory;
  }

  /**
   * @return a circle of radius 4.
   */
  public VSpatial getVSpatial(Object agent, VSpatial spatial) {
    if (spatial == null) {
      spatial = shapeFactory.createRectangle(15, 15);
    }
    return spatial;
  }

  /**
   * @return Color.BLUE.
   */
  public Color getColor(Object agent) {
    return new Color(0, 0, 255, 128);
  }

  public float getRotation(Object agent) {
    return 0f;
  }

  /*
   * (non-Javadoc)
   * 
   * @see
   * repast.simphony.visualizationOGL2D.StyleOGL2D#getBorderColor(java.lang.
   * Object)
   */
  public Color getBorderColor(Object object) {
    return Color.BLACK;
  }

  /*
   * (non-Javadoc)
   * 
   * @see
   * repast.simphony.visualizationOGL2D.StyleOGL2D#getBorderSize(java.lang.Object
   * )
   */
  public int getBorderSize(Object object) {
    return 0;
  }

  /*
   * (non-Javadoc)
   * 
   * @see
   * repast.simphony.visualizationOGL2D.StyleOGL2D#getScale(java.lang.Object)
   */
  public float getScale(Object object) {
    return 1f;
  }

  /* (non-Javadoc)
   * @see repast.simphony.visualizationOGL2D.StyleOGL2D#getLabel(java.lang.Object)
   */
  public String getLabel(Object object) {
    return null;
  }

  /* (non-Javadoc)
   * @see repast.simphony.visualizationOGL2D.StyleOGL2D#getLabelFont(java.lang.Object)
   */
  public Font getLabelFont(Object object) {
    return null;
  }

  /* (non-Javadoc)
   * @see repast.simphony.visualizationOGL2D.StyleOGL2D#getLabelPosition(java.lang.Object)
   */
  public Position getLabelPosition(Object object) {
    return Position.NORTH;
  }

  /* (non-Javadoc)
   * @see repast.simphony.visualizationOGL2D.StyleOGL2D#getLabelXOffset(java.lang.Object)
   */
  public float getLabelXOffset(Object object) {
    return 0;
  }

  /* (non-Javadoc)
   * @see repast.simphony.visualizationOGL2D.StyleOGL2D#getLabelYOffset(java.lang.Object)
   */
  public float getLabelYOffset(Object object) {
    return 0;
  }

  /* (non-Javadoc)
   * @see repast.simphony.visualizationOGL2D.StyleOGL2D#getLabelColor(java.lang.Object)
   */
  public Color getLabelColor(Object object) {
    return Color.BLACK;
  }
}
