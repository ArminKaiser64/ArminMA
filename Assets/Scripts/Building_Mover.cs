using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Building_Mover : MonoBehaviour
{
    // Start is called before the first frame update
    public Camera m_Camera;
    public float cameraX;
    public float cameraY;
    public float cameraZ;
    public float cameraXnew;
    public float cameraYnew;
    public float cameraZnew;
    public Vector3 pos1 = new Vector3(0, 0, 0);
    public Vector3 pos2 = new Vector3(0, 0, 0);
    public Vector3 movement = new Vector3(0, 0, 0);
    public Vector3 camera_viewdirection = new Vector3(0, 0, 0);
    public Quaternion rot1 = new Quaternion(0, 0, 0, 0);
    public Quaternion rot2 = new Quaternion(0, 0, 0, 0);
    public Vector3 rotationVector1 = new Vector3(0, 0, 0);
    
    void Start()
    {
        m_Camera = Camera.main;
        rotationVector1 = transform.rotation.eulerAngles;
        
        /*pos1.x += 0.5f;
        pos1.y -= 0.5f;
        pos1.z += 0.5f;*/
    }

    // Update is called once per frame
    void Update()
    {
        pos1 = m_Camera.transform.position;
        camera_viewdirection = m_Camera.transform.forward;


        gameObject.transform.position = pos1 + new Vector3(camera_viewdirection.x, camera_viewdirection.y, camera_viewdirection.z) ;
        //gameObject.transform.position = pos1 + camera_viewdirection;


        rot1 = gameObject.transform.rotation;
        rot2 = m_Camera.transform.rotation;
        rot1.x = rot1.x + rot2.x;
        rot1.y = rot1.y + rot2.y;
        rot1.z = rot1.z + rot2.z;
        var rotationVector2 = m_Camera.transform.rotation.eulerAngles;
        
        //rotationVector.z = 0;
        //transform.rotation = Quaternion.Euler(rotationVector1 + rotationVector2);
        //adjusts the orientation of the building mini-map with the direction the user is looking at
        //.rotation = Quaternion.Euler(new Vector3(rotationVector1.x, rotationVector1.y + rotationVector2.y, rotationVector1.z));

        //gameObject.transform.rotation = Quaternion.Euler(gameObject.transform.rotation.x, rot1.y, gameObject.transform.rotation.z);
        //gameObject.transform.rotation.x += m_Camera.transform.rotation.x;


        /*pos1 = m_Camera.transform.position;

        movement = pos1 - pos2;

        gameObject.transform.position = gameObject.transform.position + movement;

        pos2 = m_Camera.transform.position;
       */


    }
}
