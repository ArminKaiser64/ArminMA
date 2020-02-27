using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstantiatePosition : MonoBehaviour
{
    private GameObject obj;
    // Start is called before the first frame update
    void Start()
    {
        obj = GameObject.Find("visus_fullscale_20190826");
        Vector3 thePosition = transform.TransformPoint(2, 0, 0);
        Instantiate(obj, thePosition, obj.transform.rotation);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
