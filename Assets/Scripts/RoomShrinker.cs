using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomShrinker : MonoBehaviour
{
    private bool bla = true;
    public float dist, distanceDiff;
    private float maxX, maxY, maxZ;
    private float xMod, yMod, zMod;
    private Vector3 startScale;
    // Start is called before the first frame update
    void Start()
    {
        dist = Vector3.Distance(Camera.main.transform.position, transform.position);
        startScale = transform.localScale;
        maxX = startScale.x / 10;
        maxX = startScale.y / 10;
        maxX = startScale.z / 10;
    }

    // Update is called once per frame
    void Update()
    {
        
        distanceDiff = dist - Vector3.Distance(Camera.main.transform.position, transform.position);
        dist = Vector3.Distance(Camera.main.transform.position, transform.position);
         
        if (dist > 5)
        {
            //if (transform.localScale)
            transform.localScale += new Vector3(distanceDiff, distanceDiff, distanceDiff);


        }
        Debug.Log(startScale.x);
        if (bla)
        {
            
            //gameObject.transform.localScale -= new Vector3(1, 1, 1);
            //gameObject.transform.Translate(.5f, .5f, .5f);
            bla = false;
        }
        
    }
}
