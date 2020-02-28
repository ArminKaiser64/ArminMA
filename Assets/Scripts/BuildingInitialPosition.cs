using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildingInitialPosition : MonoBehaviour
{
    // Start is called before the first frame update
    private GameObject cube1;
    private GameObject cube2;
    private GameObject cube3;
    private GameObject cube4;
    public bool move = false;
    public bool testbool = false;
    private bool cube1Found = false;
    private bool cube2Found = false;
    private bool cube3Found = false;
    private bool cube4Found = false;
    private Vector3 direction = new Vector3(0, 0, 0);
    Vector3 rotationVector;
    private GameObject controller;
    private GameObject kamera;
    private float verschiebenX;
    private float verschiebenZ;
    

    void Start()
    {
       
        kamera = GameObject.Find("Main Camera");
        cube1 = GameObject.Find("Marker1");
        cube2 = GameObject.Find("Marker2");
        cube3 = GameObject.Find("Marker3");
        cube4 = GameObject.Find("Marker4");
        controller = GameObject.Find("ARUWP Controller");
        move = true;
        rotationVector = gameObject.transform.rotation.eulerAngles;


    }

    // Update is called once per frame
    void Update()
    {
        //checken ob alle marker erkannt wurden: Sobald alle 4 "cubes" nicht mehr an der Stelle (0,0,0) sind -> Ursprung des Gebäudes wird auf den Mittelpunkt der vier Marker gelegt.

        if (cube1.transform.position.x != 0 || cube1.transform.position.y != 0 || cube1.transform.position.z != 0)
        {
            cube1Found = true;
        }

        if (cube2.transform.position.x != 0 || cube2.transform.position.y != 0 || cube2.transform.position.z != 0)
        {
            cube2Found = true;
        }

        if (cube3.transform.position.x != 0 || cube3.transform.position.y != 0 || cube3.transform.position.z != 0)
        {
            cube3Found = true;
        }

        if (cube4.transform.position.x != 0 || cube4.transform.position.y != 0 || cube4.transform.position.z != 0)
        {
            cube4Found = true;
        }



        if (cube1Found && cube2Found && cube3Found && cube4Found && move)
        //if (Input.GetKeyDown(KeyCode.P))
        {
            cube2.transform.localScale *= 2;
            direction = cube1.transform.position - cube3.transform.position;
            
            
            //var rotationVector = (cube1.transform.rotation.eulerAngles + cube2.transform.rotation.eulerAngles + cube3.transform.rotation.eulerAngles + cube4.transform.rotation.eulerAngles) / 4;
            //transform.rotation = Quaternion.LookRotation(new Vector3(gameObject.transform.rotation.eulerAngles.x, direction.y, gameObject.transform.rotation.eulerAngles.z));
            //transform.rotation = Quaternion.Euler(new Vector3(gameObject.transform.rotation.eulerAngles.x, rotationVector.y, gameObject.transform.rotation.eulerAngles.z));


            transform.rotation = Quaternion.LookRotation(direction);
            transform.rotation = Quaternion.Euler(new Vector3(rotationVector.x, gameObject.transform.rotation.eulerAngles.y, rotationVector.z));


            //controller.GetComponent<ARUWPVideo>().enabled = false;

           



            gameObject.transform.position = (cube1.transform.position + cube2.transform.position + cube3.transform.position + cube4.transform.position) / 4;
            gameObject.transform.position = new Vector3(gameObject.transform.position.x, gameObject.transform.position.y + 0.5f, gameObject.transform.position.z);

            /*verschiebenX = gameObject.transform.position.x - kamera.transform.position.x;
            verschiebenZ = gameObject.transform.position.z - kamera.transform.position.z;

            gameObject.transform.position = new Vector3(gameObject.transform.position.x - verschiebenX, gameObject.transform.position.y, gameObject.transform.position.z - verschiebenZ);*/

            Destroy(controller);
            move = false;
            
        }

        
    }
}
