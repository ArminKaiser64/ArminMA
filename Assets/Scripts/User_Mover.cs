using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class User_Mover : MonoBehaviour
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
    private GameObject obj;
    private float faktor;
    bool move = true;
    public Vector3 camera_viewdirection = new Vector3(0, 0, 0);
    public Vector3 pos3 = new Vector3(0, 0, 0);
    public Vector3 initalPos = new Vector3(0, 0, 0);
    public Vector3 movement2 = new Vector3(0, 0, 0);
    void Start()
    {
        obj = GameObject.Find("visus_fullscale_20190826");
        m_Camera = Camera.main;
        faktor = 100 / obj.transform.localScale.x;
    }

    // Update is called once per frame
    void Update()
    {
        camera_viewdirection = m_Camera.transform.forward;

        if (move)
        {
            initalPos = obj.transform.position - camera_viewdirection;
            transform.position = obj.transform.position;
            move = false;
        }
        initalPos = obj.transform.position;
        
        pos1 = m_Camera.transform.position;

        movement = pos1 - pos2;
        movement2 = movement2 + (1 / faktor) * movement;

        //gameObject.transform.position = (gameObject.transform.position + movement + (1 / faktor) * movement);
        gameObject.transform.position = initalPos + movement2;
        //gameObject.transform.position = (gameObject.transform.position + camera_viewdirection);
        pos3 = gameObject.transform.position;
         
        //gameObject.transform.position = pos3 + camera_viewdirection;

        pos2 = m_Camera.transform.position;

    }
}
