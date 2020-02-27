using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeToMarker : MonoBehaviour
{
    private GameObject obj;
    private ARUWPMarker test;
    private int ID;
    // Start is called before the first frame update
    void Start()
    {
        obj = GameObject.Find("ARUWP Controller");
        test = obj.GetComponent<ARUWPMarker>();
        
        
    }

    // Update is called once per frame
    void Update()
    {

        //gameObject.transform.position = obj.transform.position;
        //GameObject.renderer.material.color = new Color(0.5f, 1, 1);
        //gameObject.GetComponent<Renderer>().material.SetColor("_Color", Color.red);
        ID = test.singleBarcodeID;

        if(ID == 0)
        {
            gameObject.GetComponent<MeshRenderer>().material.color = Color.blue;
        }

        /*if (ID == 12)
        {
            gameObject.GetComponent<MeshRenderer>().material.color = Color.red;
        }*/

    }
    
}
