using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Smaller_Building : MonoBehaviour
{
    private GameObject kamera;
    private float factor;
    private Vector3 pos1;
    private Vector3 pos2;
    private Vector3 movement;
    private bool changePos = false;
    void Start()
    {
        kamera = GameObject.Find("Main Camera");
        factor = 1 - (gameObject.transform.localScale.x / 100);
    }

    // Update is called once per frame
    void Update()
    {
        changePos = false;
        pos1 = kamera.transform.position;

        movement = pos1 - pos2;

        if (movement.z != 0 || movement.y != 0 || movement.x != 0)
        {
            changePos = true;
        }
        if (changePos == true)
        {
            //gameObject.transform.position = gameObject.transform.position - (movement * factor *(-1));
            //gameObject.transform.position = gameObject.transform.position + movement * factor;
            //gameObject.transform.Translate(movement * factor);
            //gameObject.transform.position = gameObject.transform.position - movement / factor;


        }

        if (Input.GetKeyDown(KeyCode.P))
        {
            gameObject.transform.position += new Vector3(0, 0, 0.1f);
        }
        pos2 = kamera.transform.position;
    }
}
