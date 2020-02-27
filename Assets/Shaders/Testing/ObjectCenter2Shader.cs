using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectCenter2Shader : MonoBehaviour
{
    private MeshRenderer cubeRenderer;
    public float centerX;
    public float centerY;
    public float centerZ;
    public Camera m_Camera;

    void Start()
    {
        cubeRenderer = gameObject.GetComponent<MeshRenderer>();
        centerX = gameObject.transform.position.x;
        centerY = gameObject.transform.position.y;
        centerZ = gameObject.transform.position.z;
        m_Camera = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {

        cubeRenderer.material.SetFloat("_CenterX", centerX);
        cubeRenderer.material.SetFloat("_CenterY", centerY);
        cubeRenderer.material.SetFloat("_CenterZ", centerZ);
        cubeRenderer.material.SetFloat("_CameraX", m_Camera.transform.position.x);
        cubeRenderer.material.SetFloat("_CameraY", m_Camera.transform.position.y);
        cubeRenderer.material.SetFloat("_CameraZ", m_Camera.transform.position.z);
    }
}
