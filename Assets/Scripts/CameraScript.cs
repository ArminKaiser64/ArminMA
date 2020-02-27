using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraScript : MonoBehaviour
{
    private MeshRenderer cubeRenderer;

    public Vector3 pos1= new Vector3(0,0,0);
    public Vector3 pos2 = new Vector3(0, 0, 0);
    public Vector3 movement = new Vector3(0, 0, 0);
    public bool changePos = false;
    public float factor;
    public GameObject cube;
    public float test;
    private GameObject obj;
    private float buildingscale;

    void Start()
    {
        cube = GameObject.Find("Cube");
        obj = GameObject.Find("visus_fullscale_20190826");
        buildingscale = obj.transform.localScale.x;
        cubeRenderer = cube.GetComponent<MeshRenderer>();
        factor = 1 - buildingscale / 100;
        //factor = 2;
    }

    // Update is called once per frame
    void Update()
    {
       
        changePos = false;
        pos1 = gameObject.transform.position;

        movement = pos1 - pos2;
        
        if (movement.z != 0 || movement.y != 0 || movement.x != 0)  {
            changePos = true;
        }
        if (changePos == true)
        {
            //gameObject.transform.position = gameObject.transform.position - (movement * factor *(-1));
            gameObject.transform.position = gameObject.transform.position - movement * (factor);
            //gameObject.transform.position = gameObject.transform.position - movement / factor;


        }
        pos2 = gameObject.transform.position;

        // returns the position where the viewer is looking at
        RaycastHit hit;

        if (Physics.Raycast(transform.position, transform.forward, out hit))
        {
            test = hit.point.x;
            cubeRenderer.material.SetFloat("_FocusPointX", hit.point.x);
            cubeRenderer.material.SetFloat("_FocusPointY", hit.point.y);
            
        }

        

    }   


}
