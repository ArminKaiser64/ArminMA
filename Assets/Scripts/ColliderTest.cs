using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColliderTest : MonoBehaviour
{
    public Vector3 nachbar1 = new Vector3(0.0f, 0.0f, 0.0f);
    public Vector3 nachbar2 = new Vector3(0.0f, 0.0f, 0.0f);
    private MeshRenderer cubeRenderer;
    private Material cubeMaterial;
    private GameObject obj;
    private GameObject leftNeighbor;
    private GameObject rightNeighbor;
    private GameObject frontNeighbor;
    private GameObject backNeighbor;
    public float rot, rot2;
    private bool sameStage = false;
    private float buildingscale;
    public float faktor;
    public float displacement, distfactor, distradius;
    Shader shader1;
    Shader shader2;
    Renderer rend;
    public GameObject cube2;

    public bool front;
    public bool back;
    public bool right;
    public bool left;
    void Start()
    {

        cube2 = GameObject.Find("Marker2");
        rend = GetComponent<Renderer>();
        shader1 = Shader.Find("Dynamic Control Shader");
        shader2 = Shader.Find("FishEyeShader_Complete");
        cubeRenderer = GetComponent<MeshRenderer>();
        //cubeRenderer.material.SetFloat("_Front", 1.0f);
        /*cubeRenderer.material.SetFloat("_MiddleX", gameObject.transform.position.x);
        cubeRenderer.material.SetFloat("_MiddleY", gameObject.transform.position.y);
        cubeRenderer.material.SetFloat("_MiddleZ", gameObject.transform.position.z);*/
        obj = GameObject.Find("visus_fullscale_20190826");
        rot = Mathf.Cos(obj.transform.eulerAngles.y * Mathf.Deg2Rad);
        buildingscale = obj.transform.localScale.x;

        faktor = (buildingscale - 10) / 40;
        displacement = Mathf.Lerp(2f, 1.0f, faktor);
        distfactor = Mathf.Lerp(1.5f, 2.0f, faktor);
        distradius = Mathf.Lerp(5.0f, 100.0f, faktor);

        if(buildingscale == 1)
        {

            displacement = 30;
            distradius = 1;
        }else if(buildingscale == 2)
        {
            displacement = 12;
            distradius = 1;
        }
        else if (buildingscale == 4)
        {
            displacement = 8;
            distradius = 1;
        }
        else if(buildingscale == 5)
        {
            displacement = 5;
            distradius = 1;
        }

        cubeRenderer.material.SetFloat("_Displacement", displacement);
        cubeRenderer.material.SetFloat("_DistortionFactor", distfactor);
        cubeRenderer.material.SetFloat("_DistortionRadius", distradius);


        if (gameObject.name == "00.005")
        {
            //Debug.Log(faktor);
            
            //Debug.Log(gameObject.transform.position.x);
            //Debug.Log( Mathf.Cos(180 * Mathf.Deg2Rad));
            //rot = obj.transform.eulerAngles.y;
            //Debug.Log(Mathf.Cos(0.0f * Mathf.Deg2Rad));
            //Debug.Log(Mathf.Cos(45.0f * Mathf.Deg2Rad));
            //Debug.Log(rot);
            //Debug.Log(obj.transform.rotation.eulerAngles.y);
        }
        
        rot2 = obj.transform.rotation.eulerAngles.y;
        cubeRenderer.material.SetFloat("_Factor", rot);
        



        //Legacy, not needed anymore
        /*if ((rot2 >= 0.0f && rot2 < 45) || (rot2 >= 180.0f && rot2 < 225))
        {
            cubeRenderer.material.SetFloat("_RotationFactor", 1.0f);
        }
        else if ((rot2 >= 45.0f && rot2 < 90) || (rot2 >= 225f && rot2 < 270))
        {
            cubeRenderer.material.SetFloat("_RotationFactor", 2.0f);
        }
        else if ((rot2 >= 90.0f && rot2 < 135) || (rot2 >= 270.0f && rot2 < 315))
        {
            cubeRenderer.material.SetFloat("_RotationFactor", 0.0f);
        }
        else if ((rot2 >= 135.0f && rot2 < 180) || (rot2 >= 315.0f && rot2 < 360))
        {
            cubeRenderer.material.SetFloat("_RotationFactor", 3.0f);
        }*/

        
    }

    // Declare and initialize a new List of GameObjects called currentCollisions.
    List<GameObject> currentCollisions = new List<GameObject>();
    
    
    void OnCollisionEnter(Collision col)
    {
        

        
        // Add the GameObject collided with to the list.
        currentCollisions.Add(col.gameObject);

        // Print the entire list to the console.
        
    }
        // Update is called once per frame
        void Update()
    {
        if (cube2.transform.localScale.x == 2)
        {


            foreach (GameObject gObject in currentCollisions)
            {

                nachbar1 = gameObject.transform.position - gObject.transform.position;
                nachbar2 = gObject.transform.position - gameObject.transform.position;
                nachbar2 = Vector3.Normalize(nachbar2);
                


                    if (gObject.name.Contains("00.") && gameObject.name.Contains("00."))
                {
                    sameStage = true;
                    //Debug.Log("Richtung x: " + nachbar2.x + "Richtung y: " + nachbar2.y + "Richtung z: " + nachbar2.z);
                    //Debug.Log("Normal: " + col.contacts[0].normal);
                }
                else if (gObject.name.Contains("01.") && gameObject.name.Contains("01."))
                {
                    sameStage = true;
                }
                else
                {
                    sameStage = false;
                }



                //Bestimmt den größten (absoluten) Wert des Richtungsvektors, da in diese Richtung der Nachbarsraum ausgedehnt werden muss.
                //Debug.Log(Mathf.Max(Mathf.Abs(nachbar1.z), Mathf.Abs(nachbar1.x), Mathf.Abs(nachbar1.y)));

                //if(Mathf.Abs(nachbar1.x) > Mathf.Abs(nachbar1.z) && Mathf.Abs(nachbar1.y) < 1.5f)

                if ((gameObject.name != "01.028" || gObject.name != "01.030") && (gameObject.name != "01.030" || gObject.name != "01.028") && (gameObject.name != "01.031" || gObject.name != "01.033") && (gameObject.name != "01.033" || gObject.name != "01.031"))
                {
                    if (Mathf.Abs(nachbar1.x) > Mathf.Abs(nachbar1.z) && sameStage)
                    {

                        if (nachbar1.x > 0)
                        {
                            cubeRenderer.material.SetFloat("_Left", 1.0f);

                            //cubeRenderer.material.SetFloat("_Width", gameObject.transform.localScale.x);
                            leftNeighbor = gObject;
                            left = true;
                            cubeRenderer.material.SetFloat("_LeftMiddleX", gObject.transform.position.x);
                            cubeRenderer.material.SetFloat("_LeftMiddleY", gObject.transform.position.y);
                            cubeRenderer.material.SetFloat("_LeftMiddleZ", gObject.transform.position.z);
                            cubeRenderer.material.SetFloat("_LeftNormalX", nachbar2.x);
                            cubeRenderer.material.SetFloat("_LeftNormalY", nachbar2.y);
                            cubeRenderer.material.SetFloat("_LeftNormalZ", nachbar2.z);


                        }
                        else
                        {
                            cubeRenderer.material.SetFloat("_Right", 1.0f);
                            //cubeRenderer.material.SetFloat("_Width", gameObject.transform.localScale.x);
                            cubeRenderer.material.SetFloat("_RightMiddleX", gObject.transform.position.x);
                            cubeRenderer.material.SetFloat("_RightMiddleY", gObject.transform.position.y);
                            cubeRenderer.material.SetFloat("_RightMiddleZ", gObject.transform.position.z);
                            cubeRenderer.material.SetFloat("_RightNormalX", nachbar2.x);
                            cubeRenderer.material.SetFloat("_RightNormalY", nachbar2.y);
                            cubeRenderer.material.SetFloat("_RightNormalZ", nachbar2.z);
                            rightNeighbor = gObject;
                            right = true;

                        }
                    }
                    //The y-Axis retrieval is for the case that there is a "neighbor" on another floor
                    //if (Mathf.Abs(nachbar1.x) < Mathf.Abs(nachbar1.z) && Mathf.Abs(nachbar1.y) < 1.5f)
                    if (Mathf.Abs(nachbar1.x) < Mathf.Abs(nachbar1.z) && sameStage)
                    {

                        if (nachbar1.z > 0)
                        {
                            cubeRenderer.material.SetFloat("_Front", 1.0f);
                            //cubeRenderer.material.SetFloat("_Width", gameObject.transform.localScale.y);
                            cubeRenderer.material.SetFloat("_FrontMiddleX", gObject.transform.position.x);
                            cubeRenderer.material.SetFloat("_FrontMiddleY", gObject.transform.position.y);
                            cubeRenderer.material.SetFloat("_FrontMiddleZ", gObject.transform.position.z);
                            cubeRenderer.material.SetFloat("_FrontNormalX", nachbar2.x);
                            cubeRenderer.material.SetFloat("_FrontNormalY", nachbar2.y);
                            cubeRenderer.material.SetFloat("_FrontNormalZ", nachbar2.z);
                            frontNeighbor = gObject;
                            front = true;
                            
                        }
                        else
                        {
                            cubeRenderer.material.SetFloat("_Back", 1.0f);
                            //cubeRenderer.material.SetFloat("_Width", gameObject.transform.localScale.y);
                            cubeRenderer.material.SetFloat("_BackMiddleX", gObject.transform.position.x);
                            cubeRenderer.material.SetFloat("_BackMiddleY", gObject.transform.position.y);
                            cubeRenderer.material.SetFloat("_BackMiddleZ", gObject.transform.position.z);
                            cubeRenderer.material.SetFloat("_BackNormalX", nachbar2.x);
                            cubeRenderer.material.SetFloat("_BackNormalY", nachbar2.y);
                            cubeRenderer.material.SetFloat("_BackNormalZ", nachbar2.z);
                            backNeighbor = gObject;
                            back = true;
                            
                        }
                    }
                }
            }
        }


        /*if (front)
        {
            cubeRenderer.material.SetFloat("_FrontMiddleX", frontNeighbor.transform.position.x);
            cubeRenderer.material.SetFloat("_FrontMiddleY", frontNeighbor.transform.position.y);
            cubeRenderer.material.SetFloat("_FrontMiddleZ", frontNeighbor.transform.position.z);
        }

        if (back)
        {
            cubeRenderer.material.SetFloat("_BackMiddleX", backNeighbor.transform.position.x);
            cubeRenderer.material.SetFloat("_BackMiddleY", backNeighbor.transform.position.y);
            cubeRenderer.material.SetFloat("_BackMiddleZ", backNeighbor.transform.position.z);
        }
        if (left)
        {
            cubeRenderer.material.SetFloat("_LeftMiddleX", leftNeighbor.transform.position.x);
            cubeRenderer.material.SetFloat("_LeftMiddleY", leftNeighbor.transform.position.y);
            cubeRenderer.material.SetFloat("_LeftMiddleZ", leftNeighbor.transform.position.z);

        }
        if (right)
        {
            cubeRenderer.material.SetFloat("_RightMiddleX", rightNeighbor.transform.position.x);
            cubeRenderer.material.SetFloat("_RightMiddleY", rightNeighbor.transform.position.y);
            cubeRenderer.material.SetFloat("_RightMiddleZ", rightNeighbor.transform.position.z);
        }*/

            cubeRenderer.material.SetFloat("_MiddleX", gameObject.transform.position.x);
            cubeRenderer.material.SetFloat("_MiddleY", gameObject.transform.position.y);
            cubeRenderer.material.SetFloat("_MiddleZ", gameObject.transform.position.z);




        /*if (Input.GetKeyDown(KeyCode.K))
        {

            rend.material.shader = shader2;
            //rend.material.shader = shader1;

        }*/
       

    }
}
